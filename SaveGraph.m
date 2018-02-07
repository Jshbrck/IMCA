function GraphOrdered = SaveGraph(hObject)
    data    = guidata(hObject); % Calls Data from IMCA_GUI
    
    TableVect = data.UserData.TableVect; % A vector of zeroes and ones corresponding to the dynamic inputs on the table in tab 3
    GraphCell = data.UserData.GraphCell; % 1x2 cell containing axes objects and activity strings. 
    Activities = data.UserData.Activity; % The activities matrix created in IMCA_GUI
    
    [numActivities ~] = size(Activities); % Returns the amount of activities.
    GraphSelected = GraphCell((TableVect == 1),:); % Limits the data to just that which was seleccted for saving.
    GraphOrdered = cell(numActivities,2); % Declares a Nx2 Cell
    GraphOrdered(:,2)=Activities(:,3); % Places activity name strings in second column.
    %%
    counter = 1; % Row Index of GraphOrdered
    stepper = 1; % Column Index of Objects within the cells in the first column of GraphOrdered.
    [sizGraphSel, ~] = size(GraphSelected); % Amount of rows of GraphSelected
    [leng, ~]        = size(GraphOrdered); % Amount of rows of GraphOrdered
    while (counter <= leng)
        for i = 1:sizGraphSel
            if (strcmp(GraphOrdered(counter,2),GraphSelected(i,2))) % Matches strings of the activities in GraphSelected in order to organize into GraphOrdered
                GraphOrdered{counter,1}(1,stepper) = GraphSelected(i,1); % Places axes object into the cell in the first column.
                stepper = stepper + 1; % Prevents overwrite in the cell by allowing for an extra column.
            end
        end
        stepper = 1; % Resets index for next GraphOrdered row.
        counter = counter + 1; % Moves to next GraphOrdered row index.
    end 
end