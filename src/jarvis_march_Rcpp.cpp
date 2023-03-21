// including necessary headers 
#include <iostream>
#include <list>
#include <cmath>
#include <vector>

#include <Rcpp.h>
using namespace Rcpp;

// creating a class for 2-dimensional points


struct point {
    
    // basic definition of a point
    double x;
    double y;
    point(double _x = 0.0, double _y = 0.0) {
        x = _x;
        y = _y;   
    }
    
    // finding the anti-clockwise angle between three points
    double acw_angle(point b, point c) {
        
        // creating vectors between the points
        point AB (b.x-x,b.y-y);
        point BC (c.x-b.x,c.y-b.y);
        
        // calculating the ACW angles between the x-axis and the vectors
        double AB_xangle {atan2(AB.y,AB.x)};
        double BC_xangle {atan2(BC.y,BC.x)};
        
        // calculating the angle between the vectors
        double angle {BC_xangle - AB_xangle};
        
        // making sure the angle is between -pi and pi
        double negative_pi {-1 * M_PI};
        while (angle <= negative_pi) {
            angle = angle + (2*M_PI);
        }
        while (angle > M_PI) {
            angle = angle - (2*M_PI);
        }
        
        // outputting the final angle
        return angle;
    
    }
    
    // finding the Euclidean distance between two points
    double dist(point p) {
        double x_dist {x-p.x};
        double y_dist {y-p.y};
        double xy_dist_2 {pow(x_dist,2)+pow(y_dist,2)};
        double xy_dist {pow(xy_dist_2,0.5)};
        return xy_dist;
    }
    
    // operator for sorting points by their x-values (if x-values are equal, then points are sorted by y-values)
    bool operator< (point p) {
        if (x < p.x) {
            return true;
        }
        else if ((x == p.x) && (y < p.y)) {
            return true;
        }
        else {
            return false;
        }
    }
    
    // operator for checking if points are equal
    bool operator== (point p) {
        if ((x == p.x) && (y == p.y)) {
            return true;
        }
        else {
            return false;
        }
    }
    
    // operator for checking if points are not equal
    bool operator!= (point p) {
        if ((x != p.x) || (y != p.y)) {
            return true;
        }
        else {
            return false;
        }
    }
    
};

// the jarvis-march algorithm from the previous assessment


std::list<point> jarvis_march_underneath(std::list<point> data) {
    
    // sort the hull based on increasing x values
    data.sort();
    
    // remove duplicates
    data.unique();
    
    // the size of the data (with duplicates removed)
    int n {0};
    for (point p: data){
        n++;
    }
    
    // creating the convex hull list (empty)
    std::list<point> hull;
    
    // case where we have only one or two points
    if (n <= 2) {
        hull = data;
        return hull;
    }
    
    // case where all points lie on a straight line
    int straight_line {1};
    std::list<point> data_minus1;
    std::list<point> data_minus2;
    data_minus1 = data;
    data_minus2 = data;
    data_minus1.pop_front();
    data_minus2.pop_front();
    data_minus2.pop_front();
    for (point r: data_minus2) {
        if ((r.acw_angle(data.front(),data_minus1.front()) != 0) && (r.acw_angle(data.front(),data_minus1.front()) != M_PI)) {
            straight_line = 0;
        }
    }
    if (straight_line == 1) {
        hull = data;
        return hull;
    }
    
    // picking the initial point based on the smallest x value
    point p0;
    p0 = data.front();
    
    // at first the hull just contains the starting point
    hull.push_back(p0);
    
    // the current point is the intial point at first
    point p_curr {p0};
    
    // defining type of variables needed inside the following loop
    std::list<point> p_next;
    int pos {0};
    int p_next_size {0};
    point p_next_1 (0,0);
    double p_dist_star {INFINITY};
    double p_dist {0};
    
    // running the algorithm until we find the solution
    while (true) {
        
        // an empty list (it will contain the possible next values of p)
        p_next.clear();
        
        // we check every point other than the current
        for (point q: data){
            if (q != p_curr){
            
                // intial value of how many angles are positive
                pos = 0;
                
                // for each point other than current p and q, we check if the angle is positive
                for (point r: data) {
                    if((r != p_curr) && (r != q)) {
                        double acw_ang {p_curr.acw_angle(q,r)};
                        if(acw_ang >= 0) {
                            pos++;
                        }
                    }
                }
                
                // if all angles are positive, we make q a possible next value of p
                if (pos == (n-2)) {
                    p_next.push_back(q);
                }
            
            }
        }
        
        // the number of next possible values of p
        p_next_size = 0;
        for (point p: p_next) {
            p_next_size++;
        }
        
        // if there is one possible next value of p, then it becomes the next p
        if (p_next_size == 1) {
            p_next_1 = p_next.front();
        }
        
        // if there are multiple possible next values of p, we choose the closest possible value of p
        if (p_next_size >= 2) {
            p_dist_star = INFINITY;
            for (point p: p_next) {
                p_dist = p.dist(p_curr);
                if (p_dist < p_dist_star) {
                    p_dist_star = p_dist;
                    p_next_1 = p;
                }
            }
        }
        
        // adding the new value to the hull
        hull.push_back(p_next_1);
        
        // making the new value the current value for the next iteration
        p_curr = p_next_1;
        
        // checking if the current value is the inital value - if so, we output the convex hull
        if (p_curr == p0) {
            return hull;
        }
        
    }
    
}

// the jarvis-march algorithm for a list of 2-vectors

// [[Rcpp::export]]
std::list<std::vector<double> > jarvis_march_points(std::list<std::vector<double> > dataset) {

    // making sure our list has only 2-vectors (if not, return an empty list)
    int n;
    for(std::vector<double> vec: dataset) {
        n = vec.size();
        if(n != 2) {
            std::list<std::vector<double> > hull;
            return hull;
        }
    }
    
    
    // converting our list of 2-vectors to a list of points
    point a;
    std::list<point> dataset_points;
    for(std::vector<double> vec: dataset) {
        a.x = vec[0];
        a.y = vec[1];
        dataset_points.push_back(a);
    }
    
    // running the jarvis-march algoirthm underneath
    std::list<point> hull_points;
    hull_points = jarvis_march_underneath(dataset_points);
    
    // converting our lists of points to a list of 4-vectors
    std::list<std::vector<double> > hull;
    std::vector<double> h;
    for (point p: hull_points) {
        h = {p.x, p.y};
        hull.push_back(h);
    }
    
    // returning the convex hull (a list of 4-vectors)
    return hull;

}
