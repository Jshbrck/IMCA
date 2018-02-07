function ret = Roundto15(X)
   roundX = mod(X, 100);
   a = roundX - 0;
   b = roundX - 15;
   c = roundX - 30;
   d = roundX - 45;
   e = roundX - 60;
   
   Array          = [a b c d e];
   [~,Index]      = min(abs(Array));
   [i, j]         = ind2sub(size(Array),Index);
   X = X - Array(i,j);
   
   if mod(X, 100) >= 60
       X = X + 40 + (mod(X,100) -60); %eg 123060 -> 123100, 123062 -> 123102
   end
   
   if (mod(X, 10000) - mod(X, 100)) >= 6000 
       X = X + 4000;
   end
   ret = X;