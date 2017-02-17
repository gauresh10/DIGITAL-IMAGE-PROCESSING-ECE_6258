function [C,count]=Union(A,B,index,inlimit,outlimit)
    count =0;
    for i =inlimit:outlimit
        if(A(i,index)==1 && B(i,index)==1 )
            C(i,index)=1;
            count=count+1;
        else if (A(i,index)==1 && B(i,index)==0 )
            C(i,index)=1;
            count=count+1;
        else if (A(i,index)==0 && B(i,index)==1 )
            C(i,index)=1;
            count=count+1;
            else
            C(i,index)=0;
            count=count+0;
            end
            end
        end
    end

end