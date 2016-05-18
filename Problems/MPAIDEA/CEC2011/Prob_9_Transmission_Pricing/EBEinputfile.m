%   IEEE 30 BUS SYSTEM FOR LOAD FLOW STUDIES

%clear all; clc;
basemva = 100;accuracy=0.0001;maxiter=10;

%			  Bus  Bus   Voltage  Angle         ---Load---            ---Generator--                   Injected
%			  No.  Code   Mag.    Degree    MW          Mvar      MW            var            Qmin      Qmax     Mvar    
bus_spec= [   1     1	  1.05  	0.0	    0.0		    0.0      165.9              0               0        0	    0.000;
	          2	    2	  1.043  	0.0	    21.7 	    12.7     49.1           28.4            -40      50	    0.000;
	          3	    0	  1.00	 	0.0	    2.4  	    1.2  	 0.0            0.0             0        0	    0.000;
              4     0     1.00      0.0     7.6         1.6      0.0            0.0             0        0       0.0 ;
              5     2     1.01      0.0     94.2        19.0     21.6           28             -40      40      0.0;
              6     0     1.00      0.0     0.0         0.0      0.0            0.0             0        0       0.0;
              7     0     1.00      0.0     22.8        10.9     0.0            0.0             0        0       0.0;
              8     2     1.01      0.0     30.0        30.0     22.8           39.1            -6       24      0.0;
              9     0     1.00      0.0     0.0         0.0      0.0            0.0             0        0       0.0;
              10    0     1.00      0.0     5.8         2.0      0.0            0.0             -6       24      0.0;
              11    2     1.082     0.0     0.0         0.0      12.4          31.6            0        0       0.0;
              12    0     1.00      0.0     11.2        7.5      0.0            0.0             0        0       0.0;
              13    2     1.071     0.0     0.0         0.0      11.6          45.7            0        0       0.0;
              14    0     1.0       0.0     6.2         1.6      0.0            0.0             0        0       0.0;
              15    0     1.0       0.0     8.2         2.5      0.0            0.0             0        0       0.0;
              16    0     1.0       0.0     3.5         1.8      0.0            0.0             0        0       0.0;
              17    0     1.0       0.0     9.0         5.8      0.0            0.0             0        0       0.0;
              18    0     1.0       0.0     3.2         0.9      0.0            0.0             0        0       0.0;
              19    0     1.0       0.0     9.5         3.4      0.0            0.0             0        0       0.0 ;      
              20    0     1.0       0.0     2.2         0.7      0.0            0.0             0        0       0.0;
              21    0     1.0       0.0     17.5        11.2     0.0            0.0             0        0       0.0;
              22    0     1.0       0.0     0.0         0.0      0.0            0.0             0        0       0.0;
              23    0     1.0       0.0     3.2         1.6      0.0            0.0             0        0       0.0;
              24    0     1.0       0.0     8.7         6.7      0.0            0.0             0        0       0.0;
              25    0     1.0       0.0     0.0         0.0      0.0            0.0             0        0       0.0;
              26    0     1.0       0.0     3.5         2.3      0.0            0.0             0        0       0.0;
              27    0     1.0       0.0     0.0         0.0      0.0            0.0             0        0       0.0;
              28    0     1.0       0.0     0.0         0.0      0.0            0.0             0        0       0.0;
              29    0     1.0       0.0     2.4         0.9      0.0            0.0             0        0       0.0;
              30    0     1.0       0.0     10.6        1.9      0.0            0.0             0        0       0.0];
          
          
          
          
 
  
    %			Bus  bus    R        X          1/2B     Tap    Line
   %            nl   nr     pu       pu           pu    Sett.  Limit
  linedata = [   1    2     0.0192+0.0575j      0.0264    1   130.00;
     			 1    3     0.0452+0.1652j      0.0204    1	  130.0000;	
     			 2    4     0.0570+0.1737j      0.0184    1	  65.0000;
                 3    4     0.0132+0.0379j      0.0042    1   130 ;         
                 2    5     0.0472+0.1983j      0.0209    1   130 ;    
                 2    6     0.0581+0.1763j      0.0187    1   65;
                 4    6     0.0119+0.0414j      0.0045    1   90;
                 7    5     0.0460+0.1160j      0.0102    1   70;
                 6    7     0.0267+0.0820j      0.0085    1   130;
                 6    8     0.0120+0.0420j      0.0045    1   32;
                 6    9     0.0000+0.2080j      0.0       1   65;
                 6    10    0.0000+0.5560j      0.0       1   32;
                 11   9     0.0000+0.2080j      0.0       1   65;
                 9    10    0.0000+0.1100j      0.0       1   65;
                 4    12    0.0000+0.2560j      0.0       1   65;           
                 13   12    0.0000+0.1400j      0.0       1   65;    
                 12   14    0.1231+0.2559j      0.0       1   32;
                 12   15    0.0662+0.1304j      0.0       1   32;
                 12   16    0.0945+0.1987j      0.0       1   32;
                 14   15    0.2210+0.1997j      0.0       1   16;
                 16   17    0.0524+0.1923j      0.0       1   16;
                 15   18    0.1073+0.2185j      0.0       1   16;
                 18   19    0.0639+0.1292j      0.0       1   16;
                 20   19    0.0340+0.0680j      0.0       1   32;
                 10   20    0.0936+0.2090j      0.0       1   32;
                 10   17    0.0324+0.0845j      0.0       1   32;
                 10   21    0.0348+0.0749j      0.0       1   32;
                 10   22    0.0727+0.1499j      0.0       1   32;
                 22   21    0.0116+0.0236j      0.0       1   32 ;
                 15   23    0.1000+0.2020j      0.0       1   16;
                 22   24    0.1150+0.1790j      0.0       1   16;
                 23   24    0.1320+0.2700j      0.0       1   16;
                 25   24    0.1885+0.3292j      0.0       1   16;
                 25   26    0.2544+0.3800j      0.0       1   16;
                 27   25    0.1093+0.2087j      0.0       1   16;
                 28   27    0.0000+0.3960j      0.0       1   65;
                 27   29    0.2198+0.4153j      0.0       1   16;
                 27   30    0.3202+0.6027j      0.0       1   16;
                 29   30    0.2399+0.4533j      0.0       1   16;
                 8    28    0.0636+0.2000j      0.0214    1   32;
                 6    28    0.0169+0.0599j      0.0065    1   32];
             
 tc=283.4*4.52*2;            
           
             
           
                    
                 
                 