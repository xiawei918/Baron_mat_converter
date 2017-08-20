function convert_to_bar(loadfilename,writefilename)
    load(loadfilename);
    n = size(H,1);
    meq = size(Aeq,1);
    m = size(A,1);
    
    writefilename = fopen(writefilename,'w');
    
    % baron parameters
    MaxTime = 10000;
    EpsR = 1e-6;
    
    % options
    formatSpec = 'OPTIONS {\n MaxTime: %d;\n EpsR: %f;\n }\n \n';
    fprintf(writefilename,formatSpec,MaxTime,EpsR);
    
    % VARIABLES
    fprintf(writefilename,'VARIABLES\t');
    for i = 1:n
        formatSpec = 'x%d,';
        if i == n
            formatSpec = 'x%d;\n';
        end
        fprintf(writefilename,formatSpec,i);
    end
    
    % LOWER_BOUNDS
    fprintf(writefilename,'LOWER_BOUNDS {\n');
    for i = 1:n
        formatSpec = 'x%d: %f;\n';
        fprintf(writefilename,formatSpec,i,LB(i));
    end
    fprintf(writefilename,'}\n\n');
    
    % UPPER_BOUNDS
    fprintf(writefilename,'UPPER_BOUNDS {\n');
    for i = 1:n
        formatSpec = 'x%d: %f;\n';
        fprintf(writefilename,formatSpec,i,UB(i));
    end
    fprintf(writefilename,'}\n\n');
    
    % EQUATIONS summary
    fprintf(writefilename,'EQUATIONS ');
    for i = 1:(m+meq)
        formatSpec = 'e%d,';
        if i == (m+meq)
            formatSpec = 'e%d;\n\n';
        end
        
        fprintf(writefilename,formatSpec,i);
    end
    
    % inequality equations
    for i = 1:m
        fprintf(writefilename,'e%d: ',i);
        first = 0;
        for j = 1:n
            c = A(i,j);
            if c > 0
                if first == 0
                    formatSpec = ' %f*x%d ';
                    first = 1;
                else
                    formatSpec = ' + %f*x%d ';
                end
            elseif c < 0
                formatSpec = ' - %f*x%d';
                first = 1;
            end
            fprintf(writefilename,formatSpec,abs(c),j);
        end
       formatSpec = ' <= %f;\n';
       fprintf(writefilename,formatSpec,b(i));
    end
    
    
    % equality equations
    for i = 1:meq
        fprintf(writefilename,'e%d: ',i+m);
        first = 0;
        for j = 1:n
            c = Aeq(i,j);
            if c > 0
                if first == 0
                    formatSpec = ' %f*x%d ';
                    first = 1;
                else
                    formatSpec = ' + %f*x%d ';
                end
            elseif c < 0
                formatSpec = ' - %f*x%d ';
                first = 1;
            end
            fprintf(writefilename,formatSpec,abs(c),j);
        end
       formatSpec = ' == %f;\n\n';
       fprintf(writefilename,formatSpec,beq(i));
    end
    
    % OBJ: minimize
    fprintf(writefilename,'OBJ: minimize\t');
    first = 0;
    for i = 1:n
        for j = 1:n
            c = H(i,j);
            if c > 0
                if first == 0
                    formatSpec = ' %f*x%d*x%d ';
                    first = 1;
                else
                    formatSpec = '+ %f*x%d*x%d ';
                end
            elseif c < 0
                formatSpec = ' - %f*x%d*x%d ';
                first = 1;
            end
            fprintf(writefilename,formatSpec,abs(c),i,j);
        end
    end
    formatSpec = ';\n';
    fprintf(writefilename,formatSpec);
    fclose(writefilename);
end