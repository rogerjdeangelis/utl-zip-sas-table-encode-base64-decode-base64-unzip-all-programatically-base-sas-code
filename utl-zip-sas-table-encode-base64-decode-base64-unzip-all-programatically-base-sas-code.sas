Zip sas table encode base64 decode base64 unzip all programatically base sas code

Converting a zipped SAS table to portable Base64 emailing the base64 text and
converting the base64 text bact to the SAS table.

  Method

     a.  Zip     d:/sd1/cars.sas7bdat to d:/sd1/cars.zip
     b.  Encode  d:/sd1/cars.zip      to d:/sd1/carsEnc.b64
     c.  Decode  d:/sd1/carsEnc.b64   to d:/sd1/carsDec.zip
     c.  Unzip   d:/sd1/carsDec.zip   to d:/sd1/carsBac.sas7bdat  ** original SAS table

https://support.selerity.com.au/hc/en-us/articles/223345708-Tip-SAS-and-Base64

see github
https://github.com/rogerjdeangelis?utf8=%E2%9C%93&tab=repositories&q=base64&type=&language=

*_                   _
(_)_ __  _ __  _   _| |_
| | '_ \| '_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
;

libname sd1 "d:/sd1";
data sd1.cars;
 set sashelp.cars(obs=10 keep= make model type origin drivetrain msrp );
run;quit;

Up to 40 obs SD1.CARS total obs=10

Obs    MAKE     MODEL                      TYPE      ORIGIN    DRIVETRAIN     MSRP

  1    Acura    MDX                        SUV       Asia        All         36945
  2    Acura    RSX Type S 2dr             Sedan     Asia        Front       23820
  3    Acura    TSX 4dr                    Sedan     Asia        Front       26990
  4    Acura    TL 4dr                     Sedan     Asia        Front       33195
  5    Acura    3.5 RL 4dr                 Sedan     Asia        Front       43755
  6    Acura    3.5 RL w/Navigation 4dr    Sedan     Asia        Front       46100
  7    Acura    NSX coupe 2dr manual S     Sports    Asia        Rear        89765
  8    Audi     A4 1.8T 4dr                Sedan     Europe      Front       25940
  9    Audi     A41.8T convertible 2dr     Sedan     Europe      Front       35940
 10    Audi     A4 3.0 4dr                 Sedan     Europe      Front       31840


*            _   _               _
  ___  _   _| |_| |_ _ __  _   _| |_
 / _ \| | | | __| __| '_ \| | | | __|
| (_) | |_| | |_| |_| |_) | |_| | |_
 \___/ \__,_|\__|\__| .__/ \__,_|\__|
                    |_|
;

 * after zipping - encoding bas64 - decoding bas64 - unzipping;

 SD1.CARSX total obs=10

Obs    MAKE     MODEL                      TYPE      ORIGIN    DRIVETRAIN     MSRP

  1    Acura    MDX                        SUV       Asia        All         36945
  2    Acura    RSX Type S 2dr             Sedan     Asia        Front       23820
  3    Acura    TSX 4dr                    Sedan     Asia        Front       26990
  4    Acura    TL 4dr                     Sedan     Asia        Front       33195
  5    Acura    3.5 RL 4dr                 Sedan     Asia        Front       43755
  6    Acura    3.5 RL w/Navigation 4dr    Sedan     Asia        Front       46100
  7    Acura    NSX coupe 2dr manual S     Sports    Asia        Rear        89765
  8    Audi     A4 1.8T 4dr                Sedan     Europe      Front       25940
  9    Audi     A41.8T convertible 2dr     Sedan     Europe      Front       35940
 10    Audi     A4 3.0 4dr                 Sedan     Europe      Front       31840


*
 _ __  _ __ ___   ___ ___  ___ ___
| '_ \| '__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
               _
  __ _     ___(_)_ __
 / _` |   |_  / | '_ \
| (_| |_   / /| | |_) |
 \__,_(_) /___|_| .__/
                |_|
;
* just in case you rerun;
%utlfkil(d:/sd1/cars.zip);
%utlfkil(d:/sd1/carsx.sas7bdat);
%utlfkil(d:/sd1/carsEnc.b64);
%utlfkil(d:/sd1/carsDec.zip);

ods package(newzip) open nopf;
ods package(newzip) add file="d:/sd1/cars.sas7bdat";
ods package(newzip) publish archive
  properties(
   archive_name="cars.zip"
   archive_path="d:/sd1"
  );
ods package(newzip) close;

LOG
NOTE: Writing NEWZIP file: d:/sd1\cars.zip

* output d:/zd1/cars.zip;

*_                                 _        _      __   _  _
| |__      ___ _ __   ___ ___   __| | ___  | |__  / /_ | || |
| '_ \    / _ \ '_ \ / __/ _ \ / _` |/ _ \ | '_ \| '_ \| || |_
| |_) |  |  __/ | | | (_| (_) | (_| |  __/ | |_) | (_) |__   _|
|_.__(_)  \___|_| |_|\___\___/ \__,_|\___| |_.__/ \___/   |_|

;

* save in autocall library;
filename ft15f001 "c:/oto/utl_b64encode.sas";
parmcards4;
%macro utl_b64encode(inp,out);

   /*
    %let inp=d:/sd1/cars.zip;
    %let out=d:/sd1/carsEnc.b64;
   */

   data _null_;
     length b64 $ 76 line $ 57;
     retain line "";
     infile "&inp" recfm=F lrecl= 1 end=eof;
     input @1 stream $char1.;
     file "&out" lrecl=76;
     substr(line,(_N_-(CEIL(_N_/57)-1)*57),1) = byte(rank(stream));
     if mod(_N_,57)=0 or EOF then do;
       if eof then b64=put(trim(line),$base64X76.);
       else b64=put(line, $base64X76.);
       put b64;
       line="";
     end;
   run;quit;

%mend utl_b64encode;
;;;;
run;quit;

%utl_b64encode(d:/sd1/cars.zip,d:/sd1/carsEnc.b64);

* OUTPUT d:/sd1/carsEnc.b64 ;

LOG
NOTE: The infile "d:/sd1/cars.zip" is:
      Filename=d:\sd1\cars.zip,
      RECFM=F,LRECL=1,File Size (bytes)=1129,
      Last Modified=15Dec2019:14:49:36,
      Create Time=15Dec2019:14:26:16

NOTE: The file "d:/sd1/carsEnc.b64" is:
      Filename=d:\sd1\carsEnc.b64,
      RECFM=V,LRECL=76,File Size (bytes)=0,
      Last Modified=15Dec2019:14:50:03,
      Create Time=15Dec2019:14:50:03

NOTE: 1129 records were read from the infile "d:/sd1/cars.zip".
NOTE: 20 records were written to the file "d:/sd1/carsEnc.b64".
      The minimum record length was 64.

*             _                    _        _      __   _  _
  ___      __| | ___  ___ ___   __| | ___  | |__  / /_ | || |
 / __|    / _` |/ _ \/ __/ _ \ / _` |/ _ \ | '_ \| '_ \| || |_
| (__ _  | (_| |  __/ (_| (_) | (_| |  __/ | |_) | (_) |__   _|
 \___(_)  \__,_|\___|\___\___/ \__,_|\___| |_.__/ \___/   |_|

;

* save in autocall library;
filename ft15f001 "c:/oto/utl_b64decode.sas";
parmcards4;
%macro utl_b64decode(inp,out);

   /*
   %let inp=d:/sd1/carsEnc.b64;
   %let out=d:/sd1/carsDec.zip;
   */

data _null_;
  length b64 $ 76 byte $ 1;
  infile "&inp" lrecl= 76 truncover length=b64length;
  input @1 b64 $base64X76.;
  if _N_=1 then putlog "NOTE: Detected Base64 Line Length of " b64length;
  file "&out" recfm=F lrecl= 1;
  do i=1 to (b64length/4)*3;
    byte=byte(rank(substr(b64,i, 1)));
    put byte $char1.;
  end;
run;quit;

%mend utl_b64decode;
;;;;
run;quit;

%utl_b64decode(d:/sd1/carsEnc.b64,d:/sd1/carsDec.zip);


* OUTPUT d:/sd1/carsDec.zip;

NOTE: The infile "d:/sd1/carsEnc.b64" is:
      Filename=d:\sd1\carsEnc.b64,
      RECFM=V,LRECL=76,File Size (bytes)=1548,
      Last Modified=15Dec2019:14:50:03,
      Create Time=15Dec2019:14:50:03

NOTE: The file "d:/sd1/carsDec.zip" is:
      Filename=d:\sd1\carsDec.zip,
      RECFM=F,LRECL=1,File Size (bytes)=0,
      Last Modified=15Dec2019:14:51:59,
      Create Time=15Dec2019:14:51:36

NOTE: Detected Base64 Line Length of 76
NOTE: 20 records were read from the infile "d:/sd1/carsEnc.b64".
      The minimum record length was 64.
      The maximum record length was 76.
NOTE: 1131 records were written to the file "d:/sd1/carsDec.zip".
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds


*    _                     _
  __| |    _   _ _ __  ___(_)_ __
 / _` |   | | | | '_ \|_  / | '_ \
| (_| |_  | |_| | | | |/ /| | |_) |
 \__,_(_)  \__,_|_| |_/___|_| .__/
                            |_|
;

 filename inzip  ZIP "d:\sd1\carsDec.zip";
 filename deczip  "d:\sd1\carsx.sas7bdat";
 data _null_;
  infile inzip(cars.sas7bdat)
        lrecl=1 recfm=F ;
  file deczip lrecl=1 recfm=f;
  input byt $char1.;
  put byt $char1.;
run;quit;

NOTE: The infile library INZIP is:
      Directory=d:\sd1\carsDec.zip

NOTE: The infile INZIP(cars.sas7bdat) is:
      Filename=d:\sd1\carsDec.zip,
      Member Name=cars.sas7bdat

NOTE: The file DECZIP is:
      Filename=d:\sd1\carsx.sas7bdat,
      RECFM=F,LRECL=1,File Size (bytes)=0,
      Last Modified=15Dec2019:14:48:31,
      Create Time=15Dec2019:14:47:53

NOTE: A total of 131072 records were read from the infile library INZIP.
NOTE: 131072 records were read from the infile INZIP(cars.sas7bdat).
NOTE: 131072 records were written to the file DECZIP.
NOTE: DATA statement used (Total process time):
      real time           0.03 seconds
      cpu time            0.03 seconds

433 !     quit;

