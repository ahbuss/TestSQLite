CREATE TABLE Data_Dictionary (
         Data_Dictionary_ID     TEXT PRIMARY KEY,
         Date                   REAL CONSTRAINT Date NOT NULL,
         Notes                  TEXT);
CREATE TABLE Family (
         Family_ID            TEXT PRIMARY KEY,
         Data_Dictionary_ID   TEXT,
         MATNR                TEXT (9) CONSTRAINT MATNR NOT NULL,
         Budget_Group         TEXT,
         FSC                  TEXT (4) CONSTRAINT FSC NOT NULL,
         COG                  TEXT (2) CONSTRAINT COG NOT NULL,
         LRC                  TEXT (3) CONSTRAINT LRC NOT NULL,
         LRC_Tech             TEXT (2) CONSTRAINT LRC NOT NULL,
         Site_Code            TEXT (1) CONSTRAINT Site_Code NOT NULL,
         BUoM                 TEXT CONSTRAINT BUoM NOT NULL,
         AAC                  TEXT (1) CONSTRAINT AAC NOT NULL,
         Commodity            TEXT (3) CONSTRAINT Commodity NOT NULL,
         CRR                  REAL CONSTRAINT CRR NOT NULL
                                CHECK (CRR >= 0),
         Dmd_Sigma            REAL CONSTRAINT Dmd_Sigma NOT NULL
                                CHECK (Dmd_Sigma >= 0),
         Dmd_Fcst             REAL CONSTRAINT Dmd_Fcst NOT NULL
                                CHECK (Dmd_Fcst >= 0),
         LCI                  TEXT (1) CONSTRAINT LCI NOT NULL,
         Min_Buy_Qty          INTEGER CONSTRAINT Min_Buy_Qty NOT NULL
                                CHECK (Min_Buy_Qty >= 0),
         Net_Price            REAL CONSTRAINT Net_Price NOT NULL
                                CHECK (Net_Price >= 0),
         NSO                  INTEGER CONSTRAINT NSO NOT NULL
                                CHECK (NSO >= 0),
         ALT                  REAL CONSTRAINT ALT NOT NULL
                                CHECK (ALT > 0),
         PDLT                 REAL CONSTRAINT PDLT NOT NULL
                                CHECK (PDLT > 0),
         PDLT_Sigma           REAL CONSTRAINT PDLT_Sigma NOT NULL
                                CHECK (PDLT_Sigma >= 0),
         RALT                 REAL CONSTRAINT RALT NOT NULL
                                CHECK (RALT >= 0),
         Rep_Ind              TEXT (1) CONSTRAINT Rep_Ind NOT NULL
                                CHECK (Rep_Ind = 'Y' OR
                                       Rep_Ind = 'N'),
         RIP                  INTEGER CONSTRAINT RIP NOT NULL
                                CHECK (RIP = 0 OR
                                       RIP = 1),
         IMEC                 INTEGER CONSTRAINT IMEC NOT NULL
                                CHECK (IMEC >= 1 AND
                                       IMEC <= 5),
         RPL                  REAL CONSTRAINT RPL NOT NULL
                                CHECK (RPL >= 0),
         RPR                  REAL CONSTRAINT RPR NOT NULL
                                CHECK (RPR >= 0),
         RTAT                 REAL CONSTRAINT RTAT NOT NULL
                                CHECK (RTAT >= 0),
         RTAT_Sigma           REAL CONSTRAINT RTAT_Sigma NOT NULL
                                CHECK (RTAT_Sigma >= 0),
         Shelf_Life           REAL CONSTRAINT Shelf_Life NOT NULL
                                CHECK (Shelf_Life >= 0),
         SR                   REAL CONSTRAINT SR NOT NULL
                                CHECK (SR >= 0),
         Standard_Price       REAL CONSTRAINT Standard_Price NOT NULL
                                CHECK (Standard_Price > 0),
         SL                   REAL CONSTRAINT SL NOT NULL
                                CHECK (SL > 0),
         EOQ_Duration         INTEGER CONSTRAINT EOQ_Duration NOT NULL
                                CHECK (EOQ_Duration > 0),
         FGC                  TEXT,
         FRC                  TEXT,
         MSD                  INTEGER CONSTRAINT MSD NOT NULL,
         Dmd_Alpha            REAL CONSTRAINT Dmd_Alpha NOT NULL
                                DEFAULT (0.2)
                                CHECK (Dmd_Alpha >=0 AND
                                       Dmd_Alpha <= 1),
         Ini_PriorCALTDT      INTEGER CONSTRAINT Ini_PriorCALTDT NOT NULL
                                CHECK (Ini_PriorCALTDT > 0),
         PDLT_Alpha_0         REAL CONSTRAINT PDLT_Alpha_0 NOT NULL
                                DEFAULT (0.2)
                                CHECK (PDLT_Alpha_0 >= 0 AND
                                       PDLT_Alpha_0 <= 1),
         PDLT_Alpha_1         REAL CONSTRAINT PDLT_Alpha_1 NOT NULL
                                DEFAULT (0.2)
                                CHECK (PDLT_Alpha_1 >= 0 AND
                                       PDLT_Alpha_1 <= 1),
         PDLT_Alpha_6         REAL CONSTRAINT PDLT_Alpha_6 NOT NULL
                                DEFAULT (0.2)
                                CHECK (PDLT_Alpha_6 >= 0 AND
                                       PDLT_Alpha_6 <= 1),
         PDLT_Alpha_12        REAL CONSTRAINT PDLT_Alpha_12 NOT NULL
                                DEFAULT (0.2)
                                CHECK (PDLT_Alpha_12 >= 0 AND
                                       PDLT_Alpha_12 <= 1),
         PDLT_Min_Thres       INTEGER CONSTRAINT PDLT_Min_Thres NOT NULL
                                DEFAULT (0)
                                CHECK (PDLT_Min_Thres >= 0),
         PDLT_Max_Thres       INTEGER CONSTRAINT PDLT_Max_Thres NOT NULL
                                DEFAULT (999)
                                CHECK (PDLT_Max_Thres >= 0),
         RTAT_Min_Thres       INTEGER CONSTRAINT RTAT_Min_Thres NOT NULL
                                DEFAULT (0)
                                CHECK (RTAT_Min_Thres >= 0),
         RTAT_Max_Thres       INTEGER CONSTRAINT RTAT_Max_Thres NOT NULL
                                DEFAULT (999)
                                CHECK (RTAT_Max_Thres >= 0),
         RTAT_Min_Obs         INTEGER CONSTRAINT RTAT_Min_Obs NOT NULL
                                DEFAULT (4)
                                CHECK (RTAT_Min_Obs >= 2),
         RTAT_Outlier_Mult    REAL CONSTRAINT RTAT_Outlier_Mult NOT NULL
                                DEFAULT (1.25)
                                CHECK (RTAT_Outlier_Mult > 0),
         On_Hand_NRFI         INTEGER
                                DEFAULT (0),
         On_Hand_RFI          INTEGER
                                DEFAULT (0),
         UCO_Qty              REAL
                                DEFAULT (0),
         SPC_THRESH           REAL CONSTRAINT SPC_THRESH NOT NULL
                                CHECK (SPC_THRESH >= 0),
         Fence_Qtrs           REAL CONSTRAINT Fence_Qtrs NOT NULL
                                CHECK (Fence_Qtrs >= 1),
         Conversion_Factor    REAL CONSTRAINT Conversion_Factor NOT NULL,
         MOS                  INTEGER CONSTRAINT MOS NOT NULL
                                CHECK (MOS > 0)
                              DEFAULT (24),
         FOREIGN KEY (Data_Dictionary_ID)
           REFERENCES Data_Dictionary (Data_Dictionary_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE);
CREATE TABLE Metric(
         Metric_ID           TEXT PRIMARY KEY,
         Description         TEXT,
         Default_Dir         TEXT (3) CONSTRAINT Default_Dir NOT NULL
                               CHECK (Default_Dir = 'min' OR
                                      Default_Dir = 'max')
                               DEFAULT ('min'),
         Active              INTEGER CONSTRAINT Active NOT NULL
                               CHECK (Active = 0 OR
                                      Active = 1)
                               DEFAULT (1),
         Units               TEXT);
CREATE TABLE Simulation(
         Sim_ID              TEXT PRIMARY KEY,
         Data_Dictionary_ID  TEXT,
         Date                REAL,
         Sim_Name            TEXT,
         Sim_Version         TEXT,
         Avail_Opt           INTEGER CONSTRAINT Avail_Opt NOT NULL
                               CHECK (Avail_Opt = 1 OR
                                      Avail_Opt = 0)
                               DEFAULT (0),
         Seed                INTEGER CONSTRAINT Seed NOT NULL
                               CHECK (Seed >= 0)
                               DEFAULT (1),
         Demand_Gen          TEXT (1) CONSTRAINT Demand_Gen NOT NULL
                               CHECK (Demand_Gen = 'P' OR
                                      Demand_Gen = 'E' OR
                                      Demand_Gen = 'T'),
         TimeSplice_Hor      REAL CONSTRAINT TimeSplice_Hor NOT NULL
                               CHECK (TimeSplice_Hor > 0),
         SimStartDate        REAL CONSTRAINT SimStartDate NOT NULL,
         Run_Length          REAL CONSTRAINT Run_Length NOT NULL
                               CHECK (Run_Length >= 0)
                               DEFAULT (0),
         Warmup              REAL CONSTRAINT Warmup NOT NULL
                               CHECK (Warmup >= 0)
                               DEFAULT (0),
         Replications        INTEGER CONSTRAINT Replications NOT NULL
                               CHECK (Replications >= 1)
                               DEFAULT (1),
         Auto_Num_PMSS_n     INTEGER CONSTRAINT Num_PMSS NOT NULL
                               CHECK (Auto_Num_PMSS_n >= 0 AND
                                      Auto_Num_PMSS_n <= 100)
                               DEFAULT (20),
         Default_PMSS        REAL CONSTRAINT Default_PMSS NOT NULL
                               CHECK (Default_PMSS >= 0)
                               DEFAULT (.001),
         Write_Detail        INTEGER CONSTRAINT Write_Detail NOT NULL
                               CHECK (Write_Detail = 0 OR
                                      Write_Detail = 1)
                             DEFAULT(0),
         FOREIGN KEY (Data_Dictionary_ID)
           REFERENCES Data_Dictionary (Data_Dictionary_ID)
             ON DELETE CASCADE
             ON UPDATE CASCADE);
CREATE TABLE Simulation_Family_Controls(
         Sim_ID              TEXT,
         Family_ID           TEXT,
         Demand_Gen          TEXT (1) CONSTRAINT Demand_Gen NOT NULL
                               CHECK (Demand_Gen = 'P' OR
                                      Demand_Gen = 'E' OR
                                      Demand_Gen = 'T'),
         TimeSplice_Hor      REAL CONSTRAINT TimeSplice_Hor NOT NULL
                               CHECK (TimeSplice_Hor > 0),
         Run_Length          REAL CONSTRAINT Run_Length NOT NULL
                               CHECK (Run_Length >= 0)
                               DEFAULT (0),
         Warmup              REAL CONSTRAINT Warmup NOT NULL
                               CHECK (Warmup >= 0)
                               DEFAULT (0),
         Replications        INTEGER CONSTRAINT Replications NOT NULL
                               CHECK (Replications >= 1)
                               DEFAULT (1),
         Auto_Num_PMSS_n     INTEGER CONSTRAINT Num_PMSS NOT NULL
                               CHECK (Auto_Num_PMSS_n >= 0 AND
                                      Auto_Num_PMSS_n <= 100)
                               DEFAULT (20),
         DRP_Int             REAL CONSTRAINT DRP_Int NOT NULL
                                 CHECK (DRP_Int > 0)
                                 DEFAULT (7),
         DRP_Hor_Proc         REAL CONSTRAINT DRP_Hor_Proc NOT NULL
                                 CHECK (DRP_Hor_Proc >= 0)
                                 DEFAULT (0),
         DRP_Hor_Rep          REAL CONSTRAINT DRP_Hor_Rep NOT NULL
                                 CHECK (DRP_Hor_Rep >= 0)
                                 DEFAULT (0),
         Organic              INTEGER CONSTRAINT Organic NOT NULL
                                 CHECK (Organic = 0 OR
                                        Organic = 1)
                                 DEFAULT (0),
         Levels_Int           INTEGER CONSTRAINT Levels_Int NOT NULL
                                 CHECK (Levels_Int > 0)
                                 DEFAULT (1),
         PO_Rep_Period        REAL CONSTRAINT PO_Rep_Period NOT NULL
                                 CHECK (PO_Rep_Period > 0)
                                 DEFAULT(10000000000000000000),
         RALT_Max_Cons        REAL CONSTRAINT RALT_Max_Cons NOT NULL
                                 CHECK (RALT_Max_Cons >= 0 AND
                                        RALT_Max_Cons <= 1)
                                 DEFAULT (.6),
         ALT_Max_Cons         REAL CONSTRAINT ALT_Max_Cons NOT NULL
                                 CHECK (ALT_Max_Cons >= 0 AND
                                        ALT_Max_Cons <= 1)
                                 DEFAULT (.6),
         Dmd_Recalc           INTEGER CONSTRAINT Dmd_Recalc NOT NULL
                                 CHECK (Dmd_Recalc = 0 OR
                                        Dmd_Recalc = 1)
                                 DEFAULT (1),
         PDLT_Recalc          INTEGER CONSTRAINT PDLT_Recalc NOT NULL
                                 CHECK (PDLT_Recalc = 0 OR
                                        PDLT_Recalc = 1)
                                 DEFAULT (1),
         RTAT_Recalc          INTEGER CONSTRAINT RTAT_Recalc NOT NULL
                                 CHECK (RTAT_Recalc = 0 OR
                                        RTAT_Recalc = 1)
                                 DEFAULT (1),
         CRR                  REAL CONSTRAINT CRR NOT NULL
                                CHECK (CRR >= 0),
         Dmd_Sigma            REAL CONSTRAINT Dmd_Sigma NOT NULL
                                CHECK (Dmd_Sigma >= 0),
         Dmd_Fcst             REAL CONSTRAINT Dmd_Fcst NOT NULL
                                CHECK (Dmd_Fcst >= 0),
         Min_Buy_Qty          INTEGER CONSTRAINT Min_Buy_Qty NOT NULL
                                CHECK (Min_Buy_Qty >= 0),
         NSO                  INTEGER CONSTRAINT NSO NOT NULL
                                CHECK (NSO >= 0),
         ALT                  REAL CONSTRAINT ALT NOT NULL
                                CHECK (ALT > 0),
         PDLT                 REAL CONSTRAINT PDLT NOT NULL
                                CHECK (PDLT > 0),
         PDLT_Sigma           REAL CONSTRAINT PDLT_Sigma NOT NULL
                                CHECK (PDLT_Sigma >= 0),
         RALT                 REAL CONSTRAINT RALT NOT NULL
                                CHECK (RALT >= 0),
         Rep_Ind              TEXT (1) CONSTRAINT Rep_Ind NOT NULL
                                CHECK (Rep_Ind = 'Y' OR
                                       Rep_Ind = 'N'),
         RIP                  INTEGER CONSTRAINT RIP NOT NULL
                                CHECK (RIP = 0 OR
                                       RIP = 1),
         IMEC                 INTEGER CONSTRAINT IMEC NOT NULL
                                CHECK (IMEC >= 1 AND
                                       IMEC <= 5),
         RTAT                 REAL CONSTRAINT RTAT NOT NULL
                                CHECK (RTAT >= 0),
         RTAT_Sigma           REAL CONSTRAINT RTAT_Sigma NOT NULL
                                CHECK (RTAT_Sigma >= 0),
         SR                   REAL CONSTRAINT SR NOT NULL
                                CHECK (SR >= 0),
         SL                   REAL CONSTRAINT SL NOT NULL
                                CHECK (SL > 0),
         RPL                  REAL CONSTRAINT RPL NOT NULL
                                CHECK (RPL >= 0),
         RPR                  REAL CONSTRAINT RPR NOT NULL
                                CHECK (RPR >= 0),
         Standard_Price       REAL CONSTRAINT Standard_Price NOT NULL
                                CHECK (Standard_Price > 0),
         Net_Price            REAL CONSTRAINT Net_Price NOT NULL
                                CHECK (Net_Price >= 0),
         EOQ_Duration         INTEGER CONSTRAINT EOQ_Duration NOT NULL
                                CHECK (EOQ_Duration > 0),
         MSD                  INTEGER CONSTRAINT MSD NOT NULL,
         Dmd_Alpha            REAL CONSTRAINT Dmd_Alpha NOT NULL
                                DEFAULT (0.2)
                                CHECK (Dmd_Alpha >=0 AND
                                       Dmd_Alpha <= 1),
         Ini_PriorCALTDT      INTEGER CONSTRAINT Ini_PriorCALTDT NOT NULL
                                CHECK (Ini_PriorCALTDT > 0),
         PDLT_Alpha_0         REAL CONSTRAINT PDLT_Alpha_0 NOT NULL
                                DEFAULT (0.2)
                                CHECK (PDLT_Alpha_0 >= 0 AND
                                       PDLT_Alpha_0 <= 1),
         PDLT_Alpha_1         REAL CONSTRAINT PDLT_Alpha_1 NOT NULL
                                DEFAULT (0.2)
                                CHECK (PDLT_Alpha_1 >= 0 AND
                                       PDLT_Alpha_1 <= 1),
         PDLT_Alpha_6         REAL CONSTRAINT PDLT_Alpha_6 NOT NULL
                                DEFAULT (0.2)
                                CHECK (PDLT_Alpha_6 >= 0 AND
                                       PDLT_Alpha_6 <= 1),
         PDLT_Alpha_12        REAL CONSTRAINT PDLT_Alpha_12 NOT NULL
                                DEFAULT (0.2)
                                CHECK (PDLT_Alpha_12 >= 0 AND
                                       PDLT_Alpha_12 <= 1),
         PDLT_Min_Thres       INTEGER CONSTRAINT PDLT_Min_Thres NOT NULL
                                DEFAULT (0)
                                CHECK (PDLT_Min_Thres >= 0),
         PDLT_Max_Thres       INTEGER CONSTRAINT PDLT_Max_Thres NOT NULL
                                DEFAULT (999)
                                CHECK (PDLT_Max_Thres >= 0),
         RTAT_Min_Thres       INTEGER CONSTRAINT RTAT_Min_Thres NOT NULL
                                DEFAULT (0)
                                CHECK (RTAT_Min_Thres >= 0),
         RTAT_Max_Thres       INTEGER CONSTRAINT RTAT_Max_Thres NOT NULL
                                DEFAULT (999)
                                CHECK (RTAT_Max_Thres >= 0),
         RTAT_Min_Obs         INTEGER CONSTRAINT RTAT_Min_Obs NOT NULL
                                DEFAULT (4)
                                CHECK (RTAT_Min_Obs >= 2),
         RTAT_Outlier_Mult    REAL CONSTRAINT RTAT_Outlier_Mult NOT NULL
                                DEFAULT (1.25)
                                CHECK (RTAT_Outlier_Mult > 0),
         Sim_NRFI             INTEGER
                                DEFAULT (0),
         Sim_RFI              INTEGER
                                DEFAULT (0),
         UCO_Qty              REAL
                                DEFAULT (0),
         SPC_THRESH           REAL CONSTRAINT SPC_THRESH NOT NULL
                                CHECK (SPC_THRESH >= 0),
         Fence_Qtrs           REAL CONSTRAINT Fence_Qtrs NOT NULL
                                CHECK (Fence_Qtrs >= 1),
         PRIMARY KEY (Sim_ID, Family_ID),
         FOREIGN KEY (Sim_ID)
           REFERENCES Simulation (Sim_ID)
           ON UPDATE CASCADE
           ON DELETE CASCADE,
         FOREIGN KEY (Family_ID)
           REFERENCES Family (Family_ID)
           ON UPDATE CASCADE
           ON DELETE CASCADE
      );
CREATE TABLE Optimization_Family_Controls(
         Opt_ID              TEXT,
         Family_ID           TEXT,
         Min_PMSS           REAL CONSTRAINT Min_PMSS
                              CHECK (Min_PMSS >= 0)
                              DEFAULT (0),
         Max_PMSS           REAL CONSTRAINT Max_PMSS
                              CHECK (Max_PMSS >= Min_PMSS)
                              DEFAULT (1000000000000000),
         PRIMARY KEY (Opt_ID, Family_ID),
         FOREIGN KEY (Opt_ID)
           REFERENCES Optimization (Opt_ID)
           ON UPDATE CASCADE
           ON DELETE CASCADE,
         FOREIGN KEY (Family_ID)
           REFERENCES Family (Family_ID)
           ON UPDATE CASCADE
           ON DELETE CASCADE
      );
CREATE TABLE Optimization(
         Opt_ID              TEXT PRIMARY KEY,
         Date                REAL,
         Opt_Name            TEXT,
         Opt_Version         TEXT,
         Max_Gap_MIP         REAL CONSTRAINT Max_Gap_MIP NOT NULL
                               CHECK (Max_Gap_MIP >= 0.0)
                               DEFAULT (0.01),
         Max_cpu_Time        REAL CONSTRAINT Max_cpu_Time NOT NULL
                               CHECK (Max_cpu_Time >= 0)
                               DEFAULT (120),
         Threads             INTEGER CONSTRAINT Threads NOT NULL
                               DEFAULT (0),
         Completed           INTEGER CONSTRAINT Completed NOT NULL
                               CHECK (Completed = 1 OR
                                      Completed = 0)
                               DEFAULT (0),
         Feasible            INTEGER CONSTRAINT Feasible
                              CHECK (Feasible = 1 OR
                                     Feasible = 0),
         Obj_Value           REAL,
         Gap_MIP             REAL,
         cpu_Time            REAL);
CREATE TABLE Demand (
         Demand_ID           TEXT PRIMARY KEY,
         Family_ID           TEXT,
         Data_Dictionary_ID  TEXT,
         UIC                 TEXT (6) CONSTRAINT UIC NOT NULL,
         AUDAT               REAL CONSTRAINT AUDAT NOT NULL
                               CHECK (AUDAT > 0),
         KWMENG              REAL CONSTRAINT KWMENG NOT NULL
                               CHECK (KWMENG > 0),
         Dem_Type            TEXT CONSTRAINT Dem_Type NOT NULL
                               CHECK (Dem_Type = 'R' OR
                                      Dem_Type = 'NR'),
         FOREIGN KEY (Family_ID)
           REFERENCES Family (Family_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE,
         FOREIGN KEY (Data_Dictionary_ID)
           REFERENCES Data_Dictionary (Data_Dictionary_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE);
CREATE TABLE Due_in(
         Due_In_ID           TEXT PRIMARY KEY,
         Family_ID           TEXT,
         Data_Dictionary_ID  TEXT,
         DocType             TEXT CONSTRAINT DocType NOT NULL
                               CHECK (DocType = 'PO' OR
                                      DocType = 'PR'),
         BUY_REPAIR          TEXT CONSTRAINT BUY_REPAIR NOT NULL
                               CHECK (BUY_REPAIR = 'BUY' OR
                                      BUY_REPAIR = 'REPAIR'),
         DueDate             REAL CONSTRAINT DueDate NOT NULL
                               CHECK (DueDate > 0),
         OpenQty             INTEGER CONSTRAINT OpenQty NOT NULL
                               CHECK (OpenQty > 0),
         Active              INTEGER (1) CONSTRAINT Active NOT NULL
                               CHECK (Active = 0 OR
                                      Active = 1),
         FOREIGN KEY (Family_ID)
           REFERENCES Family (Family_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE,
         FOREIGN KEY (Data_Dictionary_ID)
           REFERENCES Data_Dictionary (Data_Dictionary_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE);
CREATE TABLE PDLT_OBS(
         PDLT_Obs_ID         TEXT PRIMARY KEY,
         Family_ID           TEXT,
         Data_Dictionary_ID  TEXT,
         PDLT                REAL CONSTRAINT PDLT NOT NULL
                               CHECK (PDLT > 0),
         MENGE               REAL CONSTRAINT MENGE NOT NULL
                               CHECK (MENGE > 0),
         ZZDATE              REAL CONSTRAINT ZZDATE NOT NULL
                               CHECK (ZZDATE > 0),
         BEDAT               REAL CONSTRAINT BEDAT NOT NULL
                               CHECK (BEDAT > 0),
         FOREIGN KEY (Family_ID)
           REFERENCES Family (Family_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE,
         FOREIGN KEY (Data_Dictionary_ID)
           REFERENCES Data_Dictionary (Data_Dictionary_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE);
CREATE TABLE RTAT_OBS(
         RTAT_Obs_ID         TEXT PRIMARY KEY,
         Family_ID           TEXT,
         Data_Dictionary_ID  TEXT,
         RTAT                REAL CONSTRAINT RTAT NOT NULL
                               CHECK (RTAT > 0),
         Completion_Date     REAL CONSTRAINT Completion_Date NOT NULL
                               CHECK (Completion_Date > 0),
         Induction_Date      REAL CONSTRAINT Induction_Date NOT NULL
                               CHECK (Induction_Date > 0),
         FOREIGN KEY (Family_ID)
           REFERENCES Family (Family_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE,
         FOREIGN KEY (Data_Dictionary_ID)
           REFERENCES Data_Dictionary (Data_Dictionary_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE);
CREATE TABLE Simulation_Family(
         Sim_ID              TEXT,
         Family_ID           TEXT,
         Return              INTEGER CONSTRAINT Return NOT NULL
                               CHECK (Return = 0 Or
                                      Return = 1),
         Error_msg           TEXT,
         PRIMARY KEY (
           Sim_ID,
           Family_ID),
         FOREIGN KEY (Sim_ID)
           REFERENCES Simulation (Sim_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE,
         FOREIGN KEY (Family_ID)
           REFERENCES Family (Family_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE);
CREATE TABLE Simulation_Demand(
         Sim_ID              TEXT,
         Demand_ID           TEXT,
         Family_ID           TEXT,
         PRIMARY KEY (
           Sim_ID,
           Demand_ID),
         FOREIGN KEY (Sim_ID)
           REFERENCES Simulation (Sim_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE,
         FOREIGN KEY (Demand_ID)
           REFERENCES Demand (Demand_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE,
         FOREIGN KEY (Family_ID)
           REFERENCES Family (Family_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE);
CREATE TABLE Simulation_Due_In(
         Sim_ID              TEXT,
         Due_In_ID           TEXT,
         Family_ID           TEXT,
         PRIMARY KEY (
           Sim_ID,
           Due_In_ID),
         FOREIGN KEY (Sim_ID)
           REFERENCES Simulation (Sim_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE,
         FOREIGN KEY (Due_In_ID)
           REFERENCES Due_in (Due_In_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE,
         FOREIGN KEY (Family_ID)
           REFERENCES Family (Family_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE);
CREATE TABLE Simulation_PDLT_Obs(
         Sim_ID              TEXT,
         PDLT_Obs_ID         TEXT,
         Family_ID           TEXT,
         PRIMARY KEY (
           Sim_ID,
           PDLT_Obs_ID),
         FOREIGN KEY (Sim_ID)
           REFERENCES Simulation (Sim_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE,
         FOREIGN KEY (PDLT_Obs_ID)
           REFERENCES PDLT_Obs (PDLT_Obs_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE,
         FOREIGN KEY (Family_ID)
           REFERENCES Family (Family_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE);
CREATE TABLE Simulation_RTAT_OBS (
         Sim_ID              TEXT,
         RTAT_Obs_ID         TEXT,
         Family_ID           TEXT,
         PRIMARY KEY (
           Sim_ID,
           RTAT_Obs_ID),
         FOREIGN KEY (Sim_ID)
           REFERENCES Simulation (Sim_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE,
         FOREIGN KEY (RTAT_Obs_ID)
           REFERENCES RTAT_Obs (RTAT_Obs_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE,
         FOREIGN KEY (Family_ID)
           REFERENCES Family (Family_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE);
CREATE TABLE Simulation_Output(
         Sim_ID              TEXT,
         Sim_Data            BLOB,
         Format              TEXT CONSTRAINT Format NOT NULL
                               CHECK (Format = 'zip'     OR
                                      Format = 'gz'      OR
                                      Format = 'bz2'     OR
                                      Format = 'tar.gz'  OR
                                      Format = 'tar.bz2'),
         FOREIGN KEY (Sim_ID)
           REFERENCES Simulation (Sim_Id)
           ON DELETE CASCADE
           ON UPDATE CASCADE);
CREATE TABLE Simulation_Metric_Family (
         Sim_ID             TEXT,
         Metric_ID          TEXT,
         Family_ID          TEXT,
         PMSS               REAL CONSTRAINT PMSS NOT NULL
                              CHECK (PMSS >= 0),
         Achieved           REAL CONSTRAINT Achieved NOT NULL,
         Replications       INTEGER,
         PRIMARY KEY (
           Sim_ID,
           Family_ID,
           Metric_ID,
           PMSS),
         FOREIGN KEY (Sim_ID)
           REFERENCES Simulation (Sim_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE,
         FOREIGN KEY (Family_ID)
           REFERENCES Family (Family_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE,
         FOREIGN KEY (Metric_ID)
           REFERENCES Metric (Metric_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE);
CREATE TABLE Metric_controls (
         Metric_ID           TEXT,
         Dir                 TEXT (3) CONSTRAINT Dir NOT NULL
                               CHECK (Dir = 'min' OR
                                      Dir = 'max'),
         w_Achieve           REAL CONSTRAINT w_Achieve
                               CHECK (w_Achieve >= 0)
                               DEFAULT (0),
         w_DevDown           REAL CONSTRAINT w_DevDown
                               CHECK (w_DevDown >= 0)
                               DEFAULT (0),
         n_down              REAL CONSTRAINT n_down
                               CHECK (n_down >= 0)
                               DEFAULT (2.0),
         w_DevUp             REAL CONSTRAINT w_DevUp
                               CHECK (w_DevUp >= 0)
                               DEFAULT (0),
         n_up                REAL CONSTRAINT n_up
                               CHECK (n_up >= 0)
                               DEFAULT (2.0),
         AggLimits           INTEGER CONSTRAINT AggLimits NOT NULL
                               CHECK (AggLimits = 0 OR
                                      AggLimits = 1)
                               DEFAULT (0),
         Agg_v_min           REAL CONSTRAINT Agg_v_min
                               CHECK (Agg_v_min <= Agg_v_max)
                               DEFAULT (0),
         Agg_v_max           REAL CONSTRAINT Agg_v_max
                               CHECK (Agg_v_min <= Agg_v_max)
                               DEFAULT (1000000000000000),
         FOREIGN KEY (Metric_ID)
           REFERENCES Metric (Metric_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE);
CREATE TABLE Metric_Family_controls (
         Metric_ID           TEXT,
         Family_ID           TEXT,
         v_min               REAL
                               DEFAULT (0),
         v_max               REAL
                               DEFAULT (0),
         p_down              REAL CONSTRAINT p_down
                               CHECK (p_down >= 0)
                               DEFAULT (1.0),
         p_up                REAL CONSTRAINT p_up
                               CHECK (p_up >= 0)
                               DEFAULT (1.0),
         n_down              REAL CONSTRAINT n_down
                               CHECK (n_down >= 0)
                               DEFAULT (2.0),
         n_up                REAL CONSTRAINT n_up
                               CHECK (n_up >= 0)
                               DEFAULT (2.0),
         PRIMARY KEY (
           Metric_ID,
           Family_ID),
         FOREIGN KEY (Metric_ID)
           REFERENCES Metric (Metric_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE,
         FOREIGN KEY (Family_ID)
           REFERENCES Family (Family_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE);
CREATE TABLE Optimization_Metric (
         Opt_ID              TEXT,
         Metric_ID           TEXT,
         Dir                 TEXT (3),
         w_Achieve           REAL CONSTRAINT w_Achieve
                               CHECK (w_Achieve >= 0),
         w_DevDown           REAL CONSTRAINT w_DevDown
                               CHECK (w_DevDown >= 0),
         w_DevUp             REAL CONSTRAINT w_DevUp
                               CHECK (w_DevUp >= 0),
         AggLimits           INTEGER CONSTRAINT AggLimits
                               CHECK (AggLimits = 0 OR
                                      AggLimits = 1),
         Agg_v_min           REAL CONSTRAINT Agg_v_min
                               CHECK (Agg_v_min <= Agg_v_max),
         Agg_v_max           REAL CONSTRAINT Agg_v_max
                               CHECK (Agg_v_min <= Agg_v_max),
         Agg_DevDown_w       REAL CONSTRAINT Agg_DevDown_w
                               DEFAULT (1000000000000000)
                               CHECK (Agg_DevDown_w >= 0),
         Agg_DevUp_w         REAL CONSTRAINT Agg_DevUp_w
                               DEFAULT (1000000000000000)
                               CHECK (Agg_DevUp_w >= 0),
         Achieved            REAL,
         PRIMARY KEY (
           Opt_ID,
           Metric_ID),
         FOREIGN KEY (Opt_ID)
           REFERENCES Optimization (Opt_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE,
        FOREIGN KEY (Metric_ID)
           REFERENCES Metric (Metric_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE);
CREATE TABLE Optimization_Family (
         Opt_ID             TEXT,
         Family_ID          TEXT,
         Sim_ID             TEXT,
         PMSS               REAL CONSTRAINT PMSS
                              CHECK (PMSS >= 0.00),
         PRIMARY KEY (
           Opt_ID,
           Family_ID),
         FOREIGN KEY (Opt_ID)
           REFERENCES Optimization (Opt_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE,
         FOREIGN KEY (Family_ID)
           REFERENCES Family (Family_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE,
         FOREIGN KEY (Sim_ID)
           REFERENCES Simulation (Sim_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE);
CREATE TABLE Optimization_Metric_Family (
         Opt_ID            TEXT,
         Metric_ID         TEXT,
         Family_ID         TEXT,
         v_min             REAL CONSTRAINT v_min
                             CHECK (v_min <= v_max)
                             DEFAULT (0),
         v_max             REAL CONSTRAINT v_max
                             CHECK (v_min <= v_max)
                             DEFAULT (0),
         p_down            REAL CONSTRAINT p_down
                             CHECK (p_down >= 0)
                             DEFAULT (1.0),
         p_up              REAL CONSTRAINT p_up
                             CHECK (p_up >= 0)
                             DEFAULT (1.0),
         n_down            REAL CONSTRAINT n_down
                             CHECK (n_down >= 0)
                             DEFAULT (2.0),
         n_up              REAL CONSTRAINT n_up
                             CHECK (n_up >= 0)
                             DEFAULT (2.0),
         w_Achieve         REAL CONSTRAINT w_Achieve
                             DEFAULT (1.0)
                             CHECK (w_Achieve >= 0),
         Min_Achieve       REAL CONSTRAINT Min_Achieve
                             DEFAULT (0.0)
                             CHECK (Min_Achieve >= 0),
         Max_Achieve       REAL CONSTRAINT Max_Achieve
                             DEFAULT (1000000000000000)
                             CHECK (Max_Achieve >= 0),
         Achieved          REAL,
         DevDown           REAL,
         DevUp             REAL,
         PRIMARY KEY (
           Opt_ID,
           Metric_ID,
           Family_ID),
         FOREIGN KEY (Opt_ID)
           REFERENCES Optimization (Opt_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE,
         FOREIGN KEY (Metric_ID)
           REFERENCES Metric (Metric_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE,
         FOREIGN KEY (Family_ID)
           REFERENCES Family (Family_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE);
CREATE TABLE PMSS(
         PMSS_ID             TEXT PRIMARY KEY,
         Family_ID           TEXT,
         Sim_ID              TEXT,
         PMSS                Real,
         FOREIGN KEY (Family_ID)
           REFERENCES Family (Family_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE,
         FOREIGN KEY (Sim_ID)
           REFERENCES Simulation (Sim_ID)
           ON DELETE CASCADE
           ON UPDATE CASCADE);
