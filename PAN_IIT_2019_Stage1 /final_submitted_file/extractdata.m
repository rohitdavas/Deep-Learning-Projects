%% extracting data from the CSV file code 
 %------------------------------------------------------------------------  
for j = 1:6
    cat  = solution.category == j %assigning the category label 
    cat1 = solution(cat ,'id') %% accessing id
   %    [row2, col2] = find(solution == '2')
   cat1_array = cat1.id %% converting the table into array to ease of access in matlab
  

   i = 1;
   while i<size(cat1_array,1)
        x = cat1_array(i,1);
        
%adding numeric and string in matlab dir = x + ".png"

        movefile(x + ".png" , 'j','f'); %%move the image to specified label folder already made by me
                                        %%f for force writing over so if some problem occurs     
        i = i + 1;
   end
end