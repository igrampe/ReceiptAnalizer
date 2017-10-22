//
//  RAImageProcessor.cpp
//  ReceiptAnalizer
//
//  Created by Sema Belokovsky on 20.06.14.
//  Copyright (c) 2014 Sema Belokovsky. All rights reserved.
//

#import "RAImageProcessor.h"

using namespace cv;

typedef std::vector<std::vector<cv::Point> > Contours;
typedef std::vector<cv::Vec4i> Hierarchy;

struct ContoursTree {
	Contours contours;
	Hierarchy hierarchy;
};

cv::vector<cv::Mat> processImage(cv::Mat image)
{
	cv::Mat greyMat, colorMat, result;
	colorMat = cv::Mat(image);
	cv::cvtColor(colorMat, greyMat, CV_BGR2GRAY);
	
	Mat dst, cdst, blur;
	GaussianBlur(greyMat, blur, cv::Size(11,11), 0);
	Canny(blur, dst, 50, 200, 3);
	cvtColor(dst, cdst, CV_GRAY2BGR);
	
	Mat bw;
	cv::threshold(greyMat, bw, 200, 255, THRESH_OTSU);
	
	Contours contours;
	Hierarchy hierarchy;
	ContoursTree tree;
	
	cv::findContours(bw,
					 contours,
					 hierarchy,
					 CV_RETR_TREE,
					 CV_CHAIN_APPROX_SIMPLE);
	tree.contours = contours;
	tree.hierarchy = hierarchy;
	
	std::vector<cv::Point> contour;
	vector<cv::Point> approx;
	vector<vector<cv::Point> > squares;
	
	for (int i = 0; i < contours.size(); ++i) {
		contour = contours[i];
		float clen = arcLength(contour, YES);
		approxPolyDP(contour, approx, 0.02*clen, YES);
		if (approx.size() == 4 && fabs(contourArea(approx)) > 1000 && isContourConvex(approx)) {
			squares.push_back(approx);
		}
	}
		
	cv::Rect rect = boundingRect(squares[0]);
	
	cv::Rect myROI(rect.x, rect.y, rect.width, rect.height);
	
	cv::Mat cropped;
	Mat(greyMat, myROI).copyTo(cropped);
	
	cvtColor(cropped, result, CV_GRAY2BGR);
	
	
	
	
	
	int element_size = 3;
	Mat eroded;
	Mat element = getStructuringElement(cv::MORPH_ELLIPSE,
										cv::Size(element_size*1.5,element_size*1.5),
										cv::Point(element_size, element_size));
	cv::erode(result,eroded,element);


	
//	int numberOfLines[360];
//	for (int i = 0; i < 360; ++i) {
//		numberOfLines[i] = 0;
//	}
//	for (int i = 0; i < lines.size(); ++i) {
//		Vec2f line = lines[i];
//		int degree = round(180*line[1]/M_PI);
//		numberOfLines[degree] += 1;
//	}
//	int max = 0;
//	int n = 0;
//	
//	for (int i = 0; i < 360; ++i) {
//		if (numberOfLines[i] > max) {
//			max = numberOfLines[i];
//			n = i;
//		}
//	}
//	int len = std::max(cropped.cols, cropped.rows);
//    cv::Point2f pt(len/2., len/2.);
//    cv::Mat r = cv::getRotationMatrix2D(pt, -(180*(n > 90)-(double)n), 1.0);
//	cv::warpAffine(cropped, result, r, cv::Size(len, len));
	
//	cv::threshold(cropped, bw, 200, 255, THRESH_OTSU);
	
	Mat egray;
	Mat blur2;
//	GaussianBlur(result, blur2, cv::Size(11,11), 0);
	Mat ebw;
	cv::cvtColor(result, greyMat, CV_BGR2GRAY);
	cv::threshold(greyMat, ebw, 200, 255, THRESH_OTSU);
//
	Contours econtours;
	Hierarchy ehierarchy;
	ContoursTree etree;
	
	cv::findContours(ebw,
					 econtours,
					 ehierarchy,
					 CV_RETR_TREE,
					 CV_CHAIN_APPROX_SIMPLE);
	etree.contours = econtours;
	etree.hierarchy = ehierarchy;
	
//	drawContours(result, econtours, -1, cv::Scalar(0,255,0));
	
	std::vector<cv::Point> econtour;
	vector<cv::Point> eapprox;
	vector<vector<cv::Point> > esquares;
	
	for (int i = 0; i < econtours.size(); ++i) {
		econtour = econtours[i];
		float clen = arcLength(econtour, YES);
		approxPolyDP(econtour, eapprox, 0.02*clen, YES);
		if (eapprox.size() == 4 && fabs(contourArea(eapprox)) > 200 && isContourConvex(eapprox)) {
			esquares.push_back(eapprox);
		}
	}
//
//	
	vector<cv::Rect> rects;
	for (int i = 0; i < econtours.size(); ++i) {
//		vector<cv::Point> eapprox;
		cv::Rect rect = boundingRect(econtours[i]);
		
		if (rect.width * rect.height < 30 && rect.width * rect.height > 10) {
			
			rects.push_back(rect);
		}
	}
	
	vector<vector<cv::Rect>> rects2;
	vector<cv::Rect> rects3;
	for (int i =0; i < rects.size(); i++) {
		cv::Rect rect1 = rects[i];
		vector<cv::Rect> rr;
		rects2.push_back(rr);
		for (int j = 0; j < rects.size(); j++) {
			cv::Rect rect2 = rects[j];
			if (rect1.y < rect2.y+rect2.height/2 && rect1.y+rect1.height > rect2.y+rect2.height/2) {
				rects2[i].push_back(rect2);
			}
		}
		if (rects2[i].size()>15) {
			rects3.push_back(rect1);
		}
	}
	
//	for (int i =0; i < rects3.size(); i++) {
//		cv::Rect rect = rects3[i];
//		cv::Point p1, p2, p3, p4;
//		p1 = cv::Point(rect.x, rect.y);
//		p2 = cv::Point(rect.x+rect.width, rect.y);
//		p3 = cv::Point(rect.x+rect.width, rect.y+rect.height);
//		p4 = cv::Point(rect.x, rect.y+rect.height);
//		
//		cv::line(result, p1, p2, Scalar(0,0,255), 1, CV_AA);
//		cv::line(result, p2, p3, Scalar(0,0,255), 1, CV_AA);
//		cv::line(result, p3, p4, Scalar(0,0,255), 1, CV_AA);
//		cv::line(result, p4, p1, Scalar(0,0,255), 1, CV_AA);
//	}
	
	float min = MAXFLOAT;
	float max = 0;
	float height = 0;
	
	for (int i =0; i < rects3.size(); i++) {
		if (rects3[i].y < min) {
			min = rects3[i].y;
		} else if (rects3[i].y > max) {
			max = rects3[i].y;
		}
		height += rects3[i].height;
	}
	
	height /= rects3.size();
	
//	cv::Point p1, p2, p3, p4;
//	p1 = cv::Point(0, min);
//	p2 = cv::Point(result.cols, min);
//	p3 = cv::Point(result.cols, min+height);
//	p4 = cv::Point(0, min+height);
//	
//	cv::line(result, p1, p2, Scalar(0,0,255), 1, CV_AA);
//	cv::line(result, p2, p3, Scalar(0,0,255), 1, CV_AA);
//	cv::line(result, p3, p4, Scalar(0,0,255), 1, CV_AA);
//	cv::line(result, p4, p1, Scalar(0,0,255), 1, CV_AA);
//	
//	p1 = cv::Point(0, max);
//	p2 = cv::Point(result.cols, max);
//	p3 = cv::Point(result.cols, max+height);
//	p4 = cv::Point(0, max+height);
//	
//	cv::line(result, p1, p2, Scalar(0,0,255), 1, CV_AA);
//	cv::line(result, p2, p3, Scalar(0,0,255), 1, CV_AA);
//	cv::line(result, p3, p4, Scalar(0,0,255), 1, CV_AA);
//	cv::line(result, p4, p1, Scalar(0,0,255), 1, CV_AA);
	
	cv::Rect ROI(0, min+height*1.5, result.cols, max-min-height*2);
	
	cv::Mat ccropped;
	Mat(result, ROI).copyTo(ccropped);
	
	ccropped.copyTo(result);
	
	cv::Mat src;
	ccropped.copyTo(src);
	
    /* Pre-process the image to enhance the characteristics we are interested at */
	
//    medianBlur(src, src, 5);
	
    int erosion_size = 2;
    cv::Mat eelement = cv::getStructuringElement(cv::MORPH_CROSS,
												cv::Size(2 * erosion_size + 1, 2 * erosion_size + 1),
												cv::Point(erosion_size, erosion_size) );
//    cv::erode(src, src, eelement);
//    cv::dilate(src, src, eelement);
	
	Mat bw2, grey2;
	cvtColor(src, grey2, CV_BGR2GRAY);
	cv::threshold(grey2, bw2, 50, 255, THRESH_OTSU);
	
	Contours lcontours;
	Hierarchy lhierarchy;
	ContoursTree ltree;
	
	cv::findContours(bw2,
					 lcontours,
					 lhierarchy,
					 CV_RETR_TREE,
					 CV_CHAIN_APPROX_SIMPLE);
	ltree.contours = lcontours;
	ltree.hierarchy = lhierarchy;
	
	std::vector<cv::Point> lcontour;
	vector<cv::Point> lapprox;
	vector<vector<cv::Point> > lsquares;
	
	for (int i = 0; i < lcontours.size(); ++i) {
		lcontour = lcontours[i];
		float clen = arcLength(lcontour, YES);
		approxPolyDP(lcontour, lapprox, 0.02*clen, YES);
//		if (eapprox.size() == 4 && fabs(contourArea(eapprox)) > 200 && isContourConvex(eapprox)) {
		lsquares.push_back(lapprox);
//		}
	}
	
	vector<cv::Rect> rrects;
	for (int i =0; i < lcontours.size(); i++) {
		cv::Rect rect = boundingRect(lcontours[i]);
		if (rect.height * rect.width < 130 && rect.height * rect.width > 40) {
			rrects.push_back(rect);
			cv::Point p1, p2, p3, p4;
			p1 = cv::Point(rect.x, rect.y);
			p2 = cv::Point(rect.x+rect.width, rect.y);
			p3 = cv::Point(rect.x+rect.width, rect.y+rect.height);
			p4 = cv::Point(rect.x, rect.y+rect.height);
			
//			cv::line(result, p1, p2, Scalar(0,0,255), 1, CV_AA);
//			cv::line(result, p2, p3, Scalar(0,0,255), 1, CV_AA);
//			cv::line(result, p3, p4, Scalar(0,0,255), 1, CV_AA);
//			cv::line(result, p4, p1, Scalar(0,0,255), 1, CV_AA);
		}
//		NSLog(@"%d %d", rect.y, rect.y+rect.height);
		
	}
	vector<vector<cv::Rect>> rrectss;
	vector<float> mids;
	for (int i = 0; i < rrects.size(); i++) {
		cv::Rect rect1 = rrects[i];
		vector<cv::Rect> rs;
		float y = 0;
		for (int j = 0; j < rrects.size(); j++) {
			cv::Rect rect2 = rrects[j];
			if (rect1.y < rect2.y+rect2.height/2 &&
				rect1.y + rect1.height > rect2.y+rect2.height/2 && i!=j) {
				rs.push_back(rect2);
				y += rect2.y+rect2.height/2;
			}
		}
		if (rs.size() == 0) {
			y = 0;
		} else {
			y /= rs.size();
		}
		mids.push_back(y);
		rrectss.push_back(rs);
	}
	
	cv::Mat lineMat(result.rows, result.cols, CV_8UC3);
	lineMat.setTo(cv::Scalar(0,0,0));
	
	for (int i = 0; i < mids.size(); i++) {
//		int y = round(mids[i]);
//		mi[y]++;
//		NSLog(@"%f", mids[i]);
		cv::Point p1,p2;
		p1 = cv::Point(1, mids[i]);
		p2 = cv::Point(result.cols-2, mids[i]);
		cv::line(lineMat, p1, p2, Scalar(255,255,255), 1, CV_AA);
	}
	
	Mat rbw, gr;
	cvtColor(lineMat, gr, CV_BGR2GRAY);
	cv::threshold(gr, rbw, 200, 255, THRESH_OTSU);
	//
	Contours rcontours;
	Hierarchy rhierarchy;
	
	cv::findContours(rbw,
					 rcontours,
					 rhierarchy,
					 CV_RETR_TREE,
					 CV_CHAIN_APPROX_SIMPLE);
	
	vector<int> textLineYs;
	vector<cv::Mat> segments;
	for (int i =0; i < rcontours.size(); i++) {
		cv::Rect rect = boundingRect(rcontours[i]);
		int y = rect.y+rect.height/2;
		textLineYs.push_back(y);
		
//		cv::Point p1,p2;
//		p1 = cv::Point(1, y);
//		p2 = cv::Point(result.cols-2, y);
//		cv::line(result, p1, p2, Scalar(0,0,255), 1, CV_AA);
	}
	
	std::sort (textLineYs.begin(), textLineYs.begin()+textLineYs.size());
	
	for (int i = 0; i < textLineYs.size(); i++) {
		int y = textLineYs[i];
		int nextY = result.rows;
		int prevY = 0;
		if (i < textLineYs.size()-1) {
			nextY = textLineYs[i+1];
		}
		if (i > 0) {
			prevY = textLineYs[i-1];
		}
		cv::Rect roi(0, (y-(y-prevY)/1.5), result.cols, ((y-prevY)/1.5 + (nextY-y)/1.5));
		if (i == 0) {
			roi.y = 0;
			roi.height = y + (nextY-y)/1.5;
		}
		cv::Mat cropped;
		Mat(result, roi).copyTo(cropped);
		
		cv::Mat g,bww;
		cv::cvtColor(cropped, g, CV_BGR2GRAY);
		cv::threshold(g, bww, 230, 255, THRESH_OTSU);
		
		segments.push_back(bww);
	}
	
//	drawContours(result, rcontours, -1, Scalar(255,0,127));
	
//	drawContours(result, lcontours, -1, Scalar(0,255,255));
	
//	bitwise_not(bw2,bw2);
//	vector<Vec4i> lines;
//	HoughLinesP(bw2, lines, 10, CV_PI/180, 100, 0, 0);
//	for( size_t i = 0; i < lines.size(); i++ )
//	{
//		Vec4i line = lines[i];
//		cv::Point pt1, pt2;
//		pt1 = cv::Point(line[0],line[1]);
//		pt2 = cv::Point(line[2],line[3]);
//		double angle = atan2(pt2.y - pt1.y,pt2.x - pt1.x) * 180.0 / CV_PI;
//		if (fabs(angle) < 2) {
//			cv::line(result, pt1, pt2, Scalar(0,255,0), 1, CV_AA);
//		}
//	}
	
	return segments;
}