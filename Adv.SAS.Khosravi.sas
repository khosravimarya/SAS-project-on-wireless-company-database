/* it is so useful for the number of month each month
Deact_month=put(Deactdt,monname9.);
or 
data test; set dat ….;; Deact_month=put(Deactdt,monname9.); run;
proc print data=test;

;*/

LIBNAME MARY "C:\Data Analyse\Advance SAS";
PROC IMPORT OUT= F.moein2 
            DATAFILE= "C:\Users\foadm\OneDrive\Desktop\New_Wireless_Fixe
d444444444.xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="New_Wireless_Fixed$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;
proc print data=F.moein2(obs=50);run; 

/*
Mini – Project of Advanced SAS Course

Part One: Small Project for the Telecom company

Customer Distribution and Deactivation Analyses
Objective:
The attached data is the CRM data of a wireless company for 2 years. The wireless
company would like to investigate the customer distribution and business behaviors, and
then gain insightful understanding about the customers, and to forecast the deactivation
trends for the next 6 months.
Data:
Acctno: account number.
Actdt: account activation date
Deactdt: account deactivation date
DeactReason: reason for deactivation.
GoodCredit: customer’s credit is good or not.
RatePlan: rate plan for the customer.
DealerType: dealer type.
Age: customer age.
Province: province.
Sales: the amount of sales to a customer.


Analysis requests:
1.1  Explore and describe the dataset briefly. For example, is the acctno unique? What
is the number of accounts activated and deactivated? When is the earliest and
latest activation/deactivation dates available? And so on….

1.2  What is the age and province distributions of active and deactivated customers?


1.3 Segment the customers based on age, province and sales amount:
Sales segment: < $100, $100---500, $500-$800, $800 and above.
Age segments: < 20, 21-40, 41-60, 60 and above.
Create analysis report by using the attached Excel template.

1.4.Statistical Analysis:
1) Calculate the tenure in days for each account and give its simple statistics.
2) Calculate the number of accounts deactivated for each month.
3) Segment the account, first by account status “Active” and “Deactivated”, then by
Tenure: < 30 days, 31---60 days, 61 days--- one year, over one year. Report the
number of accounts of percent of all for each segment.
4) Test the general association between the tenure segments and “Good Credit”
“RatePlan ” and “DealerType.”
5) Is there any association between the account status and the tenure segments?
Could you find out a better tenure segmentation strategy that is more associated
with the account status?
6) Does Sales amount differ among different account status, GoodCredit, and
customer age segments?
Part Two:  SAS Macro Programing 
2 -1:
Write a macro that accepts a state code as a parameter and creates a table containing employees from 
that state. Display a maximum of 10 rows from the table.
***********************************************************************************************
UNIVARIATE ANALYSIS

Uninariate analysis:a
	a)Continiues   ==> 1. Visualization: Histogram, Density , Box plot ,...
					   2. Summarization: Central tendecy( mean, mode, median,...),
										 measure of position:  five_number_summary( min, Q1, Q2 or median, Q3, max)
										 measure od dispresion: Range, IQR (Inter Quartile Range), Skewness, Kurtesis

    b)Chategoic   ==>  1. Visualization: Bar Chart, Pie chart
					   2. Summarization: In table format we show frequency, proportion or percentage,  comulative Freq, Comulative percenatge	
										 and levels (name of unique values)			 



Univariate Analysis:
   For categorical columns: for summarization: freq, Mode, leveles     
                                                for visualization: Bar chart or Pie chart

 For numerical columns  :   for summarization: Central tedency(mean, median, mode,...) and five_number_summary(min,Q1,median(Q2),Q3,Max), stdandard deviation ,...
                                                For visualization: Histogram and density, Box plot,... 


************************************************************************************************;
*  ;
************************************************************************************************;
Continues Vs. Categorical:

 For summarization: group by categorical column an aggregate for numerical column
 For visualization: Grouped box plot,Grouped histogram,Grouped density,...
 For test of independence :1) if categorical column has only two levels :t-test
                                                  2) if categorical column has more than two levels: ANOVA*/


*Bivariate Analysis:
  Continouse Vs. Continouse   : For Visualization scatter plot,...
                                For test of independence: Pearson correlation or spearman or  ...
    
  Categorical Vs. Categorical : For summaraization: contingency ??????? table (two-way table)
                                For visualization :stacked bar chart,Grouped bar chart,...
                                For test of independence:chi-square test

Continouse Vs. Categorical  : For summarization: group by categorical column an aggregate for numerical column
                              For visualization: Grouped box plot,...
                              For test of independence :1) if categorical column has only two levels :t-test
                                 2) if categorical column has more than two levels: ANOVA












 */
/*Analysis requests:
1.1  Explore and describe the dataset briefly. For example, is the acctno unique? What
is the number of accounts activated and deactivated? When is the earliest and
latest activation/deactivation dates available? And so on….*/
*By using sql;
*HOW MANY UNIQUE (ID)or acctno unique ;
title"acctno unique";
PROC SQL;
 SELECT COUNT(DISTINCT Acctno) AS UNI_Acctno_COUNT
 FROM F.moein2 
 ;
 QUIT;

*is the number of accounts activated and deactivated? 
TOTAL deactivated;

proc contents data=F.moein2 ;
run;
*DROP DUPLICATE OBSERVATION IF EXIST;
PROC SORT DATA=F.moein2 OUT=F.moein3 NODUPKEY;
 BY _ALL_;
RUN;
/*1.1  Explore and describe the dataset briefly. For example, is the acctno unique? What
is the number of accounts activated and deactivated? When is the earliest and
latest activation/deactivation dates available? And so on….


/*************************************not nessary***************************************************
*****************************************************************************************************
**********/
/*1. SRS : SIMPLE RANDOM SAMPLING;*/
*******PROC SURVEYSELECT DATA = F.moein2  OUT=SRS_SAMPLE METHOD=SRS SAMPRATE=0.1 SEED = 1234 ;
*******RUN;*sample size=0.1 *50000 =5000;
PROC SURVEYSELECT DATA = F.moein2  OUT=SRS_SAMPLE METHOD=SRS SAMPSIZE=5000  SEED = 1234;
RUN;
proc print data=SRS_SAMPLE;run;
PROC SQL;
 SELECT COUNT(DISTINCT Acctno) AS UNI_Acctno_COUNT
 FROM SRS_SAMPLE 
 ;
 QUIT;
 /***********************************************************************************************
 **************************************************************************************************/
proc print data=F.moein2(obs=100) ;    
   format Sales dollar10.2;
   
run;
*is the number of accounts activated and deactivated? 
TOTAL deactivated;



title"the latest activation in sample";
TITLE "THIS IS DESCRIPTIVE ANALYSIS OF ALL CONTINUOUS VARIABLES";

proc means data=F.moein2 nmiss mean std stderr cv lclm uclm median min max Q1 Q3 qrange maxdec=2;
var Age Sales;
title 'Summary of Age & Sales';
run;


*CONTINOUSE DATA : VISUALIZE METHODS;
*Age;
proc univariate data=F.moein2;
var Age;
run;
title "This is hisogram for Age";
Proc sgplot data=F.moein2; * we use prodc sgplot to create a graph except pie chart;
 histogram Age;
 density Age;
 density Age/type=kernel;
Run;
Quit;
title "This is horizontal box plot for Age";
Proc sgplot data=F.moein2;
hbox Age; *hbox For Horizontal box plot and for vbox vertical box plot;
run;
*Categorical DATA : VISUALIZE METHODS;
PROC SGPLOT DATA = F.moein2;
VBAR Province;
TITLE 'This is bar chart for Province';
RUN;
proc freq data=F.moein2;
    table Province;
run;
*pie Chart;
/* Create the pie chart */
/* Set the graphics environment */
goptions reset=all cback=white border htitle=12pt htext=10pt;  

title1 "bar chart for DealerType";
proc freq data=F.moein2;
    table DealerType;
run;
proc gchart data=F.moein2;
   pie DealerType/ other=0
              midpoints="A1" "A2" "B1" "C1" 
              value=none
              percent=arrow
              slice=arrow
              noheading 
              plabel=(font='Albany AMT/bold' h=1.3 color=depk);
run;
quit; 

*Link for provide Gragh in SAS 
https://medium.com/swlh/sas-data-visualisation-9223dc30e039
https://support.sas.com/en/knowledge-base/graph-samples-gallery.html
;



title"the number of active account in sample";
PROC SQL;
 SELECT COUNT(*)AS active_account
 FROM F.moein2
 WHERE Deactdt IS MISSING
 ;
 QUIT;
title"the number of deactive account in sample";
PROC SQL;
 SELECT COUNT(*)AS active_account
 FROM F.moein2
 WHERE Deactdt IS not MISSING
 ;
 QUIT;
title"the percent  of reasons for deactdt in sample";
proc freq data=F.moein2;
    table DeactReason;
run;
title;

/*When is the earliest and
latest activation*/



PROC SORT DATA = F.moein2 OUT= test1;
 BY Actdt  ;* ;
RUN;
proc print data=test1(obs=5);run;
*Head;
title"the earliest activation in sample";
proc print data=test1 (obs=1);run;
*Tail;
title"the latest activation in sample";
proc print data=test1 (obs=102255 firstobs=102255);run;

/* 1.2  What is the age and province distributions of active and deactivated customers?*/

data test2;
set test1;*(KEEP = Acctno actdt deactdt);
LENGTH status $ 12.;
IF  Deactdt eq . THEN status="active"; else status="deactivated";run;
PROC PRINT DATA= test2(obs=50);
RUN;
*categorical variabels: frequancy;
PROC FREQ DATA=test2;
 TABLE status /MISSING;
 * by adding Missing you specify that ypou want to consider missing values in percentage as well;
RUN;
PROC FREQ DATA=test2;
TABLE province*Status;
RUN;




title"age distributions of active and deactivated customers";

DATA test5;
 SET test2;*(KEEP = Age  Province status Sales);
 LENGTH Age_GROUP $ 9.;

 IF 0 < Age < 20 THEN Age_GROUP = "group 1";
 ELSE IF 20< Age < 40  THEN Age_GROUP = "group 2";
ELSE IF 40< Age < 60 THEN Age_GROUP = "group 3";

ELSE IF Age GE 60THEN Age_GROUP  = "group4";
 ELSE Age_GROUP = "missing";*"NOT DEFINED" or "missing";
RUN;

PROC PRINT DATA = test5(obs=25);run;

******************************not neccessary ****************************************************
*************************************************************************************************;
data test6;
  set test5;*(KEEP =  Province Age_GROUP  );
       if status="active"  then status1=1;
    else                status1=0;
run;
proc print data=test6;
 run;
 ************************************************************************************************
 ************************************************************************************************;
*CAT/CAt;
PROC FREQ DATA=test5;
TABLE Age_GROUP*Status;
RUN;
PROC FREQ DATA=test6;
TABLE Province*Status1;
RUN;

* CAT/CAT;
/*1.3 Segment the customers based on age, province and sales amount:
Sales segment: < $100, $100---500, $500-$800, $800 and above.
Age segments: < 20, 21-40, 41-60, 60 and above.
Create analysis report by using the attached Excel template.*/

proc format;
value agefmt
low-<20 ="group 1"
20-<40 ="group 2"
40-<60 ="group 3"

60-high ="group 4"
;run;
PROC PRINT DATA = test2(obs=50);run;
proc format;
value salefmt
low-<100 ="<100"
100-<500 ="100<s<500"
500-<800 ="500<s<800"
800-high ="s>800"
;run;
PROC PRINT DATA = test2(obs=50);
format Age agefmt. SALES salefmt.;

run;



DATA test7;
 SET test5;
 LENGTH sales_GROUP $ 12.;
 IF 0 < Sales <100 THEN sales_GROUP = "<100";
 ELSE IF 100< Sales < 500 THEN sales_GROUP = "100<s<500";
ELSE IF 500< Sales < 800 THEN sales_GROUP = "500<s<800";
ELSE IF Sales GE 800 THEN sales_GROUP  = "s>800";
 ELSE sales_GROUP = "missing";*"NOT DEFINED" or "missing";
RUN;

PROC PRINT DATA = test7(obs=50);run;

PROC FREQ DATA=test7;
TABLE sales_GROUP * Age_GROUP;
* whithout * we have 2 table but by * we could show them in one table;
RUN;
Proc sgplot data=test7;
vbar Age_GROUP/group=sales_GROUP; *hbox For Horizontal box plot and for vbox vertical box plot;
run;




PROC FREQ DATA=test7;
TABLE sales_GROUP * Province;
* whithout * we have 2 table but by * we could show them in one table;
RUN;
PROC FREQ DATA=test7;
TABLE Age_GROUP * Province;
* whithout * we have 2 table but by * we could show them in one table;
RUN;
Proc sgplot data=test7;
vbar Province/group=sales_GROUP; *hbox For Horizontal box plot and for vbox vertical box plot;
run;
Proc sgplot data=test7;
vbar sales_GROUP/group=Province; *hbox For Horizontal box plot and for vbox vertical box plot;
run;


/*1.4.Statistical Analysis:
1) Calculate the tenure in days for each account and give its simple statistics.
2) Calculate the number of accounts deactivated for each month.
3) Segment the account, first by account status “Active” and “Deactivated”, then by
Tenure: < 30 days, 31---60 days, 61 days--- one year, over one year. Report the
number of accounts of percent of all for each segment.
4) Test the general association between the tenure segments and “Good Credit”
“RatePlan ” and “DealerType.”
5) Is there any association between the account status and the tenure segments?
Could you find out a better tenure segmentation strategy that is more associated
with the account status?
6) Does Sales amount differ among different account status, GoodCredit, and
customer age segments?*/



*1) Calculate the tenure in days for each account and give its simple statistics.;

title"the number of active account in sample";
PROC SQL;
 SELECT COUNT(*)AS active_account
 FROM test1
 WHERE Deactdt IS MISSING
 ;
 QUIT;
title"the tenure in days for each account that was deactivated in sample";
  * not nessery;
PROC PRINT DATA =test1(obs=100);FORMAT Actdt DATE9. Deactdt DATE9.;
RUN;
* delet missing value in special var;
DATA Deactdt_NOTMISSING2;
 SET test1;
 If  NOT MISSING(Deactdt);
RUN;
proc print DATA =Deactdt_NOTMISSING2(obs=100);run;
*Calculate the tenure in days for each account and give its simple statistics;
* Correct answer for this part:**********************************************************************8;

dATA test99;
 SET test2;*(KEEP = Age  Province status Sales);
  IF Deactdt=. THEN tenure=intck('day',Actdt,'20JAN2001'd);
  ELSE tenure=intck('day',Actdt,Deactdt);*"NOT DEFINED" or "missing";
RUN;

PROC PRINT DATA = test99(obs=25);run;

***************************************************************************************************;
title"the tenure in days for each  was deactivated data in sample";

title"the tenure in days for each  was activated data in sample";

DATA Deactdt_MISSING2;
 SET test1;
 If  MISSING(Deactdt);
RUN;
proc print DATA =Deactdt_MISSING2(obs=100);run;
*Calculate the tenure in days for each account and give its simple statistics;
data test8;
set test2;
tenure=intck('day',Actdt,'20JAN2001'd);
run;
proc print DATA =test8(obs=50);run;

*2) Calculate the number of accounts deactivated for each month.;

proc sql;
create table table_x as 
select Deactdt, Actdt,
intck('month',Actdt,'15JAN2001'd)as monthes
from test1(obs =50)
;
QUIT;
proc print data=table_x (obs=50);run;

proc sql;
create table table_x as 
select Deactdt, Actdt,
intck('month',Actdt,'15JAN2001'd)as monthes
from test1(obs =50)
;
QUIT;
proc print data=table_x (obs=50);run;
proc sql;
create table table_x as 
select Deactdt,Actdt,
intck('month',Actdt,Deactdt)as monthes
from test1(obs =50)
where Deactdt is not missing
;
QUIT;
proc print data=table_x (obs=50);run;


/*3) Segment the account, first by account status “Active” and “Deactivated”, then by
Tenure: < 30 days, 31---60 days, 61 days--- one year, over one year. Report the
number of accounts of percent of all for each segment.*/


title"the number of active account(exclude  deactivated ones) in sample";
PROC SQL;
 SELECT COUNT(*)AS active_account
 FROM test1
 WHERE Deactdt IS MISSING
 ;
 QUIT;
*title"the tenure in days for each account that was deactivated in sample";
  * not nessery;
PROC PRINT DATA =test1(obs=100);FORMAT Actdt DATE9. Deactdt DATE9.;
RUN;
* delet missing value in special var;
DATA Deactdt_NOTMISSING2;
 SET test1;
 If  NOT MISSING(Deactdt);
RUN;
proc print DATA =Deactdt_NOTMISSING2(obs=100);run;
title"the number of  account that was deactivated";
PROC SQL;
 SELECT COUNT(*)AS deactivated
 FROM test1
 WHERE Deactdt IS not MISSING
 ;
 QUIT;
*title"the number of account that was deactivated(without deactive) in sample";
/*3) Segment the account, first by account status “Active” and “Deactivated”, then by
Tenure: < 30 days, 31---60 days, 61 days--- one year, over one year. Report the
number of accounts of percent of all for each segment.*/
data test9;
set test99;
LENGTH Tenure_GROUP $ 20.;
 IF 0 < Tenure < 30 THEN Tenure_GROUP = "< 30 days";
 ELSE IF 30< Tenure < 60  THEN Tenure_GROUP = "31-60 days";
ELSE IF 61< Tenure < 365 THEN Tenure_GROUP = "61 days--- one year";
ELSE IF Tenure GE 365 THEN Tenure_GROUP  = "over one year";
 ELSE Tenure_GROUP = " ";*"NOT DEFINED" or "missing";
RUN;
data test9;
set test9;*(KEEP = Acctno actdt deactdt);
LENGTH status $ 12.;
IF  Deactdt eq . THEN status="active"; else status="deactivated";run;
PROC PRINT DATA= test9(obs=50);
RUN;

PROC FREQ DATA=test9;
TABLE status/list;
* whithout * we have 2 table but by * we could show them in one table;
RUN;
PROC FREQ DATA=test9;
TABLE status*Tenure_GROUP/list ;
* whithout * we have 2 table but by * we could show them in one table;
RUN;




/*4) Test the general association between the tenure segments and “Good Credit”
“RatePlan ” and “DealerType.”


Continouse Vs. Categorical  : For summarization: group by categorical column an aggregate for numerical column
                              For visualization: Grouped box plot,...
                              For test of independence :1) if categorical column has only two levels :t-test
                                 2) if categorical column has more than two levels: ANOVA

 Categorical Vs. Categorical : For summaraization: contingency ?????????????? table (two-way table)
                                For visualization :stacked bar chart,Grouped bar chart,...
                                For test of independence:chi-square test


*/

title"association between the tenure and Good Credit
(Continouse Vs. Categorical)t-test ";
/*A t-tests is used 
1.to test whether the mean of one variable is significantly different than a hypothesized value. 
2.We also determine whether means for two independent groups are significantly different and 
3.whether means for dependent or paired groups are significantly different.

*/
/*this sample will be correct when you want to check that special H0 for one var is correct or 
not- or we have an special HO
EXAMPLE;*/

proc means data=test8;
var tenure;
run;
proc ttest data  = test8 /* the dataset name */
		   h0    = 320     /* the H0:mean=320 */
		   sided = 2       /* two-sided(two-tailed test) Ha: mu ne 80 */
		   alpha = 0.05;   /* the significance level: 5% */
	var tenure;   /* the variable name in the dataset */
run;
proc ttest data=test8 h0=320;
   var tenure;
   freq GoodCredit;
run;
*TWO SAMPLES i.e two different groupes;


/* Two independent sample comparisons: each subject measure one time */
*Example: based on follwing dataset we want to find out is there any association between gender and score;
*Null Hypottesis: there is no  association between gender and score
 Alternative hypothesis : There is association between gender and score
for INSTANCE:
proc ttest data=scores 
      class Gender
      var Score
   run
;
 proc ttest data=test8 ;
      class GoodCredit;
      var tenure;
   run;
* we reject the null hypothesis and there are corelation and assosiation between tenure & GoodCredit;

title"association between the tenure segments and Good Credit
(Categorical Vs. Categorical) chi-square test";
/*if we want to check assosiation between tenure segmentation as groups with good credit then we need to use 
 Categorical Vs. Categorical test (chi-square test ).*/

proc freq data= test9;
title"association between the tenure segments and Good Credit
(Categorical Vs. Categorical) chi-square test";
table Tenure_GROUP*GoodCredit/chisq out=out_GoodCredit;run; 
* we reject the null hypothesis and there are corelation and assosiation between tenure & GoodCredit
 ;
proc freq data= test9;
title"association between the tenure segments and RatePlan
(Categorical Vs. Categorical) chi-square test";
table Tenure_GROUP*RatePlan/chisq out=out_RatePlan;run; 
* we reject the null hypothesis and there are corelation and assosiation between tenure & RatePlan
 ;

proc freq data= test9;
title"association between the tenure segments and DealerType
(Categorical Vs. Categorical) chi-square test";
table Tenure_GROUP*DealerType/chisq out=out_DealerType;run; 
* we reject the null hypothesis and there are corelation and assosiation between tenure & DealerType
 ;

*5) Is there any association between the account status and the tenure segments?
Could you find out a better tenure segmentation strategy that is more associated
with the account status?
we want to check corelation and assosiation between two categorical data;

proc freq data= test9;
title"association between the tenure segments and DealerType
(Categorical Vs. Categorical) chi-square test";
table Tenure_GROUP*DealerType/chisq out=out_DealerType;run; 
/*5) Is there any association between the account status and the tenure segments?
Could you find out a better tenure segmentation strategy that is more associated
with the account status?*/
proc freq data= test9;
title"association between the tenure segments and account status
(Categorical Vs. Categorical) chi-square test";
table Tenure_GROUP*status/chisq out=out_status;run; 
* we see that  the null hypothesis is rejected and there are corelation and assosiation between tenure & status
 i  think we could have a better segmentation for Example (1-less than30 day 2- less than 62 days 3- less
than 180 days 4-less than one year 5- less than 18 monthes 6-less than 2 years, because the most deactivation was hpappend
after one year then we need to investigation more in the second years of agreement;



/*6) Does Sales amount differ among different account status, GoodCredit, and
customer age segments?
Continouse Vs. Categorical  : For summarization: group by categorical column an aggregate for numerical column
                              For visualization: Grouped box plot,...
                              For test of independence :1) if categorical column has only two levels :t-test
                                 2) if categorical column has more than two levels: ANOVA
*/

title"Sales amount differ among different account status";
proc sgplot data=test7;
vbar status/response=sales stat=sum nostatlabel;
xaxis display=(nolable);
yaxis grid;run;



proc univariate data=test9 normal;
class status;
var sales;
qqplot /normal ;
*Specifying MU=EST (stand for estimate) and SIGMA=EST with the NORMAL primary option requests the reference line for which 
mu(population mean) and sigma(population standard deviation) are estimated by the sample mean and standard deviation.;
run;
* the result show us there is not normality distribution but data set is so large therefor we 
rely on centeral limit theorem;

proc ttest data=test9 ;
      class status;
      var Sales;
   run;
* we  do not reject the null hypothesis and there are not corelation and assosiation between
   status & Sales;
 

title"Sales amount differ among different GoodCredit";
proc sgplot data=test7;
vbar GoodCredit/response=sales stat=sum nostatlabel;
xaxis display=(nolable);
yaxis grid;run;
proc ttest data=test9 ;
      class GoodCredit;
      var Sales;
   run;
*  the null hypothesis is not rejected then there are not corelation and assosiation between
  GoodCredit & Sales;
 
title"Sales and client age groups";
proc sgplot data=test7;
vbar sales_GROUP/response=Age stat=sum nostatlabel;
xaxis display=(nolable);
yaxis grid;run;

proc print data=test7(obs=20);run;
PROC ANOVA DATA = test7;
 CLASS Age;
 MODEL sales_GROUP = Age;
 MEANS Age/Scheffe;
 /*we can consider that at least two group means are statistically 
 signicant from each other if p-value is less than  0.05. So far, the ANOVA only tells you all group
 means are not statistically significant equal. It does not tell you  where the difference lies.
 For further multiple comparison, we still need Scheffe’s or Tukey test.*/
 
RUN;
PROC ANOVA DATA = test7;
 CLASS Age_GROUP;
 MODEL sales = Age_GROUP;
 MEANS sales/Scheffe;
 /*we can consider that at least two group means are statistically 
 signicant from each other if p-value is less than  0.05. So far, the ANOVA only tells you all group
 means are not statistically significant equal. It does not tell you  where the difference lies.
 For further multiple comparison, we still need Scheffe’s or Tukey test.*/
 
RUN;

* OR;
title"***";
proc glm data=test7;
class Age_GROUP;
model sales = Age_GROUP;* model target = predictor1 predector2 ... we want to predict height based 
on region;
means Age_GROUP / hovtest=levene(type=abs) welch;
run;
* we  could not reject the null hypothesis and there are not corelation and assosiation between
  Age & Sales;


proc univariate data=test5 normal; 
		qqplot sales /Normal( color=red l=1);
		by Age_GROUP;
		run;

*****************************************************************************************************
**************************************BMO (PART 2)***************************************************
		*************************************************************************************

/*TASK:Technical interview question for BMO :
Title: SAS Data Analyst
Rate: 68.71/hr INC or 60.59/hr T4
We are looking for a talented individual to join our team in the position of Data Analyst.
The primary responsibility ??????? ????is to leverage???? ???? customer data to deliver data and recommendations
that drive optimal ?????customer journeys and experience.
The role will sit on the Enterprise????? ????? Customer Analytics team and support Marketing and LOB
partners across
BMO FG with proactive????, actionable insights on Retail ???? ?????and Wealth customers.  

Required Skills and Experience:
•	2 years of tech skills: SAS EG, PROC SQL, SAS DATA STEP, merging (inner and outer join) and aggregating data across different granularities (transaction, account rolled up to customer) and time frame (daily, monthly)
•	Soft Skills: ability to adapt to team operating standards and existing processes, strong attention to detail and able to QA results, time management and ability to work under pressure
•	Does not have to be from a bank but large enterprise environment - not ETL ppl - this is a marketing dpt.
•	Nice to have: communication with non technical people
Key Accountabilities:

•	Perform data analysis in SAS
•	Create reports for Executives in Excel
•	Manage and enhance daily/weekly/monthly channel reporting 
•	Manage, prioritize, and respond to ad-hoc requests
•	Leveraging statistical approaches (A/B testing, time series analysis) against multiple sources of data including internal sales/transactions and external party data/benchmarks 
•	Deliver targeted campaign leads in a multichannel environment
********************************************************************************************************
BMO.Activity_checking dataset:
Obs Client_ID Account_ID Open_Date Assets Status 
1 1001 20032 02NOV19 7744 Active 
2 1002 20056 12DEC20 -12451 Inactive 
3 1003 20032 12JAN19 1274 Active 
4 1003 20074 19JAN19 7683 Active 
5 1002 20793 17SEP17 -591 Active 
6 1004 20142 16FEB17 14144 Active 
7 1005 21943 24OCT16 13981 Active 
8 1006 29371 09JUN08 14049 Inactive 
9 1002 29081 05APR18 2092 Active 

BMO.Activity_creditcard dataset:

Obs Client_ID Account_ID Open_Date credit_status Assets 
1 1003 313058 17DEC15 Active -4059 
2 1004 339524 16JAN19 Active -4327 
3 1002 330572 26SEP19 Active 15392 
4 1003 396821 07FEB20 Inactive -1359 
5 1004 375271 15MAR18 Active -1601 
6 1003 373859 09SEP20 Active 16515 
7 1006 383733 08NOV17 Inactive 5226 
8 1006 353413 16MAR18 Inactive 13741 
9 1005 365605 25JUN17 Active -4110 



Create a summary report tracking the below KPI metrics for all active clients
1.BMO_Since_Date: the first date when the customer started relationship with BMO
2.Product1_Since_Date: The first date when customer joined Product1(checking)
3.Product2_Since_Date: The first date when customer joined Product2(credit)
4.Total_Actives: Total active accounts under customer
5.Total_Assests: Total assests for each customer
*/
LIBNAME MARY "C:\Data Analyse\Advance SAS";


title "BMO_checking dataset";
DATA BMO_checking;
INPUT Client_ID Account_ID Open_Date date7. Assets  Status $;
FORMAT Open_Date DATE9.;
DATALINES;
1001 20032 02NOV19 7744 Active 
1002 20056 12DEC20 -12451 Inactive 
1003 20032 12JAN19 1274 Active 
1003 20074 19JAN19 7683 Active 
1002 20793 17SEP17 -591 Active 
1004 20142 16FEB17 14144 Active 
1005 21943 24OCT16 13981 Active 
1006 29371 09JUN08 14049 Inactive 
1002 29081 05APR18 2092 Active 
;

RUN;
PROC PRINT DATA = BMO_checking;RUN;
footnote ;
footnote ;
footnote ;



title "BMO_creditcard dataset";
DATA BMO_creditcard;
INPUT Client_ID Account_ID Open_Date date7. credit_status $ Assets;
    
FORMAT Open_Date DATE9.;
DATALINES;
1003 313058 17DEC15 Active -4059 
1004 339524 16JAN19 Active -4327 
1002 330572 26SEP19 Active 15392 
1003 396821 07FEB20 Inactive -1359 
1004 375271 15MAR18 Active -1601 
1003 373859 09SEP20 Active 16515 
1006 383733 08NOV17 Inactive 5226 
1006 353413 16MAR18 Inactive 13741 
1005 365605 25JUN17 Active -4110 
;

RUN;
PROC PRINT DATA = BMO_creditcard;RUN;


title "BMO_Activity_checking dataset";
DATA Activity_checking;
 SET BMO_checking;
 WHERE Status EQ "Active"; 
 
RUN;
proc print DATA =Activity_checking ;run;


title "BMO_Activity_creditcard dataset";
DATA Activity_creditcard;
 SET BMO_creditcard;
 WHERE credit_status EQ "Active"; 
 
RUN;
proc print DATA = Activity_creditcard ;run;


title "Activity_checking_And_Activity_creditcard";

DATA Activity_checking_And_creditcard;*;
 SET Activity_checking   Activity_creditcard;* ;
RUN;
PROC PRINT DATA = Activity_checking_And_creditcard;RUN;


title "checking_And_creditcard for all clients";
DATA all_clients;*;
 SET BMO_checking   BMO_creditcard;* ;
RUN;
PROC PRINT DATA = all_clients ;RUN;


/*Q1=1.BMO_Since_Date: the first date when the customer started relationship with BMO*/

PROC SORT DATA = all_clients OUT= all_clients1;
 BY Client_ID  Open_Date;* ;
RUN;
proc print data=all_clients1;run;

title"the first date when the customer started relationship with BMO";
DATA all_clients2;
set all_clients1 keep =Open_Date;run;
PROC PRINT DATA = all_clients2(obs=1);RUN;



/*Q2=2.Product1_Since_Date: The first date when customer joined Product1(checking)*/

PROC SORT DATA = BMO_checking OUT= BMO_checking1;
 BY Client_ID Open_Date;
RUN;
proc print data=BMO_checking1;run;



/*Q3=3.Product2_Since_Date: The first date when customer joined Product2(credit)*/


PROC SORT DATA = BMO_creditcard OUT= BMO_creditcard1;
 BY Client_ID  Open_Date;
RUN;
proc print data=BMO_creditcard1;run;



/* Q4=4.Total_Actives: Total active accounts under customer  ????? ???? ??? ???? ??? ????? */

title ".Total_Actives: Total active accounts under customer";

DATA Activity_checking_And_creditcard;*;
 SET Activity_checking   Activity_creditcard;* ;
RUN;
PROC PRINT DATA = Activity_checking_And_creditcard;RUN;

PROC SORT DATA = Activity_checking_And_creditcard OUT= result1;
 BY Client_ID  ;
RUN;
proc print data=result1;run;

DATA result2;
 SET result1;
 BY Client_ID;
 IF FIRST.Client_ID THEN  active_accounts=1;
 ELSE active_accounts+1;
 IF LAST.Client_ID;
;
 RUN;
PROC PRINT DATA = result2;RUN;



/*Q5=.Total_Assests: Total assests for each customer ????? ?????? ?? ???? ?? ?????
*/
title"Total_Assests: Total assests for each customer";
PROC SORT DATA = all_clients OUT= all_clients1;
 BY Client_ID  Open_Date;* ;
RUN;
proc print data=all_clients1;run;



DATA all_clients2;
 SET all_clients1;
 BY Client_ID;
 IF FIRST.Client_ID THEN TOTAL_TRAN=1;
 ELSE TOTAL_TRAN+1;
 IF FIRST.ID THEN TOTAL_AST = Assets;
 ELSE TOTAL_AST+Assets;
 IF LAST.Client_ID;/*or IF LAST.ID THEN OUTPUT;*//*or IF LAST.ID THEN OUTPUT hmd.CUX_02;*/
 *when ever you are creating only one data , you can skip telling THEN OUTPUT and name of that data;
 DROP Account_ID  Open_Date  Assets  Status  credit_status ;
;
 RUN;
PROC PRINT DATA = all_clients2;RUN;




title;


/*******************************************THE END********************************************************
***************************************************************************************************
***************************************************************************************************
**********************************************************************************************************;
/***********************************************************************************************
***********************************************************************************************
***********************************************************************************************/

proc univariate data=read normal; 
		qqplot grade /Normal(mu=est sigma=est color=red l=1);
		by method;
		run;


proc univariate data=test5 normal;
by Age_GROUP;
var sales;
qqplot /normal;
*Specifying MU=EST (stand for estimate) and SIGMA=EST with the NORMAL primary option requests the reference line for which mu(population mean) and sigma(population standard deviation) are estimated by the sample mean and standard deviation.;
run;*Because 


proc univariate data=nudge normal;
class province;
var conversion_rate nudge_adoption;
qqplot /normal (mu=est sigma=est);
*Specifying MU=EST (stand for estimate) and SIGMA=EST with the NORMAL primary option requests the reference line for which 
mu(population mean) and sigma(population standard deviation) are estimated by the sample mean and standard deviation.;
run;

* Using If for Subsetting of data;
DATA test8;
 SET test1;

 IF 0<Deactdt  then output test8; *Hint:There is one serious problem with this program’s logic. Missing numeric values are treated logically as the most negative number you can reference on your computer;
* in this example because we just create only one dataset we don't have to say " then output DATES01" ==>
 *IF TENURE_YR LE 5 then output DATES01 = IF TENURE_YR LE 5 then output= IF TENURE_YR LE 5 ;
RUN;


data test2;
set test1;*(KEEP = Acctno actdt deactdt);
LENGTH status $ 12.;
IF  Deactdt eq . THEN status="active"; else status="deactivated";run;
PROC PRINT DATA= test2(obs=50);
RUN;

data test8;
set test1(KEEP = Acctno );
LENGTH dates $ 12.;
IF  Deactdt >0 THEN dates=Deactdt - Actdt; run;
PROC PRINT DATA= test2;
RUN;

proc freq data=test1;
  table Deactdt/missing ;
  
run;

proc sql;
create table test8 as
select
     Acctno,Actdt,Deactdt
     WHERE Deactdt IS MISSING
from
     test1

quit;

proc sql;
create table test8 as
select
     Acctno,Actdt,Deactdt
     
     Deactdt - Actdt as Length_of_stay
from
     test1
group by Acctno;
quit;

data test6;
  set test5;
  if status='Alive';
  *or
  if status='Alive' then output active
  or
  if status='Alive' then output 
  ;
  if Smoking>0 then Smoker='Y';
  else              Smoker='N';
run;
proc print data=active;run;

DATA hmd.ENG_GROUP;
 SET SASHELP.CARS (KEEP = ORIGIN MAKE TYPE EngineSize??? ???? ????? ???? ??? ???? );
 LENGTH ENG_GROUP $ 12.;
 IF EngineSize EQ . THEN ENG_GROUP = "MISSING";
 ELSE IF EngineSize LE 2 THEN ENG_GROUP = "LOW";
 ELSE IF EngineSize < 4  THEN ENG_GROUP = "INTERMEDIATE";
 ELSE  ENG_GROUP = "HIGH";
RUN;


DATA hmd.ENG_GROUP2;
 SET SASHELP.CARS (KEEP = ORIGIN MAKE TYPE EngineSize );
 LENGTH ENG_GROUP $ 12.;

 IF 0 < EngineSize LE 2 THEN ENG_GROUP = "LOW";
 ELSE IF 2< EngineSize < 4  THEN ENG_GROUP = "INTERMEDIATE";
 ELSE IF EngineSize GE 4 THEN ENG_GROUP = "HIGH";
 ELSE ENG_GROUP = "NOT DEFINED";*"NOT DEFINED" or "missing";
RUN;

PROC PRINT DATA = hmd.ENG_GROUP;

data active;
  set sashelp.heart;
  if status='Alive';
  *or
  if status='Alive' then output active
  or
  if status='Alive' then output 
  ;
  if Smoking>0 then Smoker='Y';
  else              Smoker='N';
run;
proc print data=active;run;

DATA SUMMARY_incorrect;
SET SALES_S;
BY ID;
IF  FIRST.ID THEN TOTAL_AMT=0;
TOTAL_AMT+AMOUNT;*THIS IS SUM STATEMENT;
IF FIRST.ID THEN TOTAL_TRANS=0;
TOTAL_TRANS+1;
RETAIN ??? ???? ALL_PRODUCT;*we define new variable;
LENGTH ALL_PRODUCT $200;
ALL_PRODUCT=CATX(",",ALL_PRODUCT,PRODUCT);
*CATX:Removes leading and trailing blanks, inserts delimiters,and returns a concatenated character string. 
; ???? ??? ????? ? ??????? ?? ??? ?? ???? ???????? ?? ?? ??? ?? ???? ? ?? ???? ??????? ?? ?? ?????? ?? ???? ??????.
/*IF LAST.ID THEN OUTPUT;*/
/*DROP AMOUNT PRODUCT T_DATE;*/
RUN;
PROC PRINT DATA=  SUMMARY_incorrect;
RUN;
data active;
  set sashelp.heart;
  if status='Alive';
  *or
  if status='Alive' then output active
  or
  if status='Alive' then output 
  ;
  if Smoking>0 then Smoker='Y';
  else              Smoker='N';
run;
proc print data=active;run;
