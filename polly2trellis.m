
function p=polly2trellis()

code = zeros(1,20);
dataword = [1 0 1 0 1 1 1 1 0 1];
G1 = [0 0 0 0 0 0 0 0 0];
G2 = [0 0 0 0 0 0 0 0 0];
m = 8;
n = 2;
codeword = '00000000000000000000';
perc = zeros(1,510);
G = dlmread('generators.txt');
C = fileread('codeword.txt');
f = fopen('biterror.txt','w');
for j=1:130305,
    g1 = sprintf('%09d',G(j,1));
    g2 = sprintf('%09d',G(j,2));
    c=sprintf('%020d',C(j));
        for l=1:9,
            G1(l) = str2double(g1(l));
            G2(l) = str2double(g2(l));
        end
        for l=1:20,
               if c(l)=='1'
            code(l) = 1;
               else
                   code(l)=0;
               end
        end
        op1=zeros(2^m,4); 
        % The first and second columns in the op1 refer to the output we get 
        % when the input is 0 and the state is i-1
        % The third and fourth columns in the op1 refer to the output we get
        % when the input is 1 and the state is i-1
        nextStates=zeros(2^m,2);
        %The first column refers to the state achieved when the input is 0 and the
        %state is i-1
        %The second column refers to the state achieved when the input is 1 and the
        %state is i-1


        for i=1:1:2^m
            if mod(i-1,2)==0
                nextStates(i,1)=(i-1)/2;
                nextStates(i,2)=(i-1)/2+2^(m-1);
            elseif mod(i-1,2)~=0
                nextStates(i,1)=(i-2)/2;
                nextStates(i,2)=(i-2)/2+2^(m-1);
            end
        end
      
        for i=1:1:2^m
            index=i-1;
            c=de2bi(index,m,'left-msb');
            array0=[0, c];
            valarray0=G1.*array0;
            valarray1=G2.*array0;
            sum0=mod(sum(valarray0),2);
            sum1=mod(sum(valarray1),2);
            op1(i,1)=sum0;
            op1(i,2)=sum1;
            array1=[1, c];
            valarray0=G1.*array1;
            valarray1=G2.*array1;
            sum0=mod(sum(valarray0),2);
            sum1=mod(sum(valarray1),2);
            op1(i,3)=sum0;
            op1(i,4)=sum1;

        end

        for i=1:2^m
            output(i,1)=op1(i,1)*2+op1(i,2)*1;
            output(i,2)=op1(i,3)*2+op1(i,4)*1;
        end

        trellis=struct('numInputSymbols',2^1,'numOutputSymbols',2^2,...
           'numStates',2^m,'nextStates',nextStates,'outputs',output);
        [isok,status]=istrellis(trellis);
        codewithnoise=awgn(code,1);
        decode=vitdec(codewithnoise,trellis,2,'cont','unquant');
        biterror = biterr(decode,dataword);
        fprintf(f,'%d\n',biterror);
end
    fclose(f);
   
end

