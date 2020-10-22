function [flag] = gearOpt_dataOut(zopt,dim_opt,dim_out,fopt,name)

fileName = name;

[num_gear,~] = size(dim_opt);

for i = 1:num_gear
    
    sheetTitle = ['Data for Gear #' num2str(i)];
    
    T = { ...
        'Gear #', num2str(i), ' ';
        ' ' , ' ', ' '; 
        'Bore diam.', zopt(6), '(m)';
        'Hub OD', dim_opt(i,1), '(m)';
        'Rim diam.', dim_opt(i,2), '(m)';
        'Root diam.', dim_opt(i,3), '(m)';
        'Spoke width' dim_opt(i,4), '(m)';
        'Tooth thickness', zopt(7), '(m)';
        'Addendum', dim_out(i,5), '(m)';
        'Dedendum', dim_out(i,7), '(m)';
        'Tooth height', dim_out(i,8), '(m)';
        'Gear modulus', zopt(1), ' ';
        'Pressure angle', zopt(2), '(radians)';
        'Helix angle', zopt(4), '(radians)';
        'Face width', zopt(3), '(m)';
        'Hub width', zopt(5), '(m)';
        'Tooth count', dim_out(i,9), ' ';
        'Spoke count', dim_out(i,10), ' ';
        'Gear volume', fopt, 'm^3';
        };

    xlswrite(fileName,T,sheetTitle);

end

Message = {'Gear data displayed in the accompanying worksheets.'};
Author = {'Dimensions optimized using gearOpt authored by C.Merrikin'};

message = [Message;' ';Author];
xlswrite(fileName,message,'Sheet1');


if isfile(name)
    flag = 'Data exported to xls file\n';
    
else 
    flag = 'Error occured, Data not exported\n';
end

end