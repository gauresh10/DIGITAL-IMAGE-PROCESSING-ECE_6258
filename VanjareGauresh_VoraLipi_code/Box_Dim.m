function [xpt, ypt, width, height]=Box_Dim(newlogoPolygon,tol)
         

                width = abs(newlogoPolygon(2,1) - newlogoPolygon(1,1))+tol*3;
                height = abs(newlogoPolygon(3,2) - newlogoPolygon(2,2))+tol*3;
                xpt=newlogoPolygon(1,1)-tol;
                ypt=newlogoPolygon(1,2)-tol;
end