dataword = [1 0 1 0 1 1 1 1 0 1];

m = dlmread('generators.txt');
[row,col] = size(m);

codeword = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];

for i=1:row,
    g1 = sprintf('%09d',m(i,1));
    g2 = sprintf('%09d',m(i,2));
    shift = [0 0 0 0 0 0 0 0 0];
    for j=1:10,
        x1 = 0;
        x2 = 0;
        shift = [dataword(j), shift(1:end-1)];
        for k=1:9,
            if g1(k) == '1'
                x1 = xor(shift(k),x1);
            end
            if g2(k) == '1'
                x2 = xor(shift(k),x2);
            end
        end
        codeword(2*j-1) = x1;
        codeword(2*j) = x2;
    end
    x = num2str(codeword);
    x(isspace(x)) = '';
    cd{i} = x;
end

f = fopen('codeword.txt','w');
for r=1:row
    fprintf(f,'%s\n',cd{r});
end

fclose(f);

        
    