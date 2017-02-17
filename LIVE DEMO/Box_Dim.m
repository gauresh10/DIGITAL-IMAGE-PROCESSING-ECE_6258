function [xpt, ypt, width, height]=Box_Dim(Boxpoly)
%         width = abs(Boxpoly(2,1) - Boxpoly(1,1));
%         height = abs(Boxpoly(3,2) - Boxpoly(2,2));
%         xpt=Boxpoly(1,1);
%         ypt=Boxpoly(1,2);
        tol = 10;
        width = abs(Boxpoly(2,1) - Boxpoly(1,1))+tol*3;
            height = abs(Boxpoly(3,2) - Boxpoly(2,2))+tol*3;
            xpt=Boxpoly(1,1)-tol;
            ypt=Boxpoly(1,2)-tol;
end