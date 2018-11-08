function [rad,int] = CheckFiles(data)
rad1 = data.data(:,1); int1=data.data(:,2);
rad1 = rad1 - rad1(1); %adjust the array so that outside of explant is 0;
maxrad = max(rad1);

checking = 1;
while checking == 1;
    for i = 1:length(rad1)-1
        if rad1(i+1) ~= rad1(i)+5
            rad1 = nancat(1,rad1(1:i),rad1(i)+5,rad1(i+1:end));
            int1 = nancat(1,int1(1:i),NaN,int1(i+1:end));
        end
    end
    testarray = 0:5:maxrad; 
    if isequal(testarray',rad1)
        display('array corrected')
        checking = 0;
    else 
        display('___')
        checking =1;
    end
end

rad = rad1;
int = int1;
    
    





