library(stringr)

run_analysis = function() {
  # 1. Merges the training and the test sets to create one data set.
  df1 = slurp_data('train','X_train.txt') 
  df2 = slurp_data('test','X_test.txt')
  df = rbind(df1,df2) # append test data to training data
  # 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
  flabels = slurp_features("","features.txt")
  flmsi = grep("mean|std",flabels$V2)  # get index of all labels with mean or stdev
  flms = flabels$V2[flmsi]  # get all labels with mean or stdev
  flbool = grepl("mean|std",flabels$V2)  # get a TRUE|FALSE set for labels with mean or stdev
  df_stats=df[,flbool]  # only get columns with labels that include "mean" or "std"
  # 3. Uses descriptive activity names to name the activities in the data set
  af1 = slurp_data('train','y_train.txt') 
  af2 = slurp_data('test','y_test.txt')
  af = rbind(af1,af2) # append test data to training data
  alabels = slurp_features("","activity_labels.txt")
  afactors = alabels[,2] # get the six activities as a (factor) vector
  af$label = afactors[af$V1] # add a column to af that has the descriptive activity name
  df_stats = cbind(df_stats,af$label)
  # 4. Appropriately labels the data set with descriptive variable names. 
  dfs_names_noact = as.character(flms) # get mean and std labels
  dfs_names = as.character(flms) # get same, dunno if R makes a copy, so play it safe
  dfs_names[length(dfs_names)+1] = 'activity'
  names(df_stats) = dfs_names
  # 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  df_stats_mean = tapply(df_stats[[1]],df_stats$activity,mean)
  
  for (i in 2:(ncol(df_stats)-1)) {
    stat = tapply(df_stats[[i]],df_stats$activity,mean)
    df_stats_mean = rbind(df_stats_mean, stat)
    message(paste("i =",i,"- dim =",dim(df_stats_mean)))
  }
#  rownames(df_stats_mean) = dfs_names_noact
  df_stats_mean
}

slurp_data = function(dir,fn) {
  # get data file
  f=finddatafile(dir,fn)
  # read it in, each line is one big entry
  a=read.csv(f,header=FALSE)
  # convert to list
  b=as.list(a[[1]])
  a = NULL # save space, comment this out to debug
  # remove leading and trailing blanks
  c=sapply(b,str_trim)
  b = NULL # save space, comment this out to debug
  # convert tabs to spaces, then multi-spaces to comm
  d=sapply(c,mygsub,"\t"," ")
  c = NULL # save space, comment this out to debug
  e=sapply(d,mygsub," +"," ")
  d = NULL # save space, comment this out to debug
  # and change the (now single-) space to a comma
  f=sapply(e,mygsub," ",",")
  e = NULL # save space, comment this out to debug
  # now convert each line to a single-row data frame,
  #  and glue them together. do first one, then loop
  con=textConnection(f[1])
  frame=read.csv(con,header=FALSE)
  close(con)  # tidy up
  for (i in 2:length(f)) {
    con=textConnection(f[i])
    tempframe=read.csv(con,header=FALSE)
    frame=rbind(frame,tempframe)
    close(con)  # tidy up
  }
  frame
}

slurp_features = function(dir,fn) {
  # get data file
  f=finddatafile(dir,fn)
  message("file=",f)
  # read it in, each line is one big entry
  a=read.csv(f,sep=" ",header=FALSE)
  a
}

# gsub with the string in front (for sapply)
mygsub = function(str,pattern, repl) {
  gsub(pattern, repl, str)
}

finddatafile = function(subdir,fn) {
  fileLoc = NULL
  if (file.exists(fn)) {
    fileLoc = fn
  } else {
    fn1=paste0(subdir,"/",fn)
    if (file.exists(fn1)) {
      fileLoc = fn1
    } else {
      fn2=paste0("UCI HAR Dataset/",subdir,"/",fn)
      if (file.exists(fn2)) {
        fileLoc = fn2
      } else {
        stop(paste("cannot find",fn,"or",fn1,"or",fn2))
      }
    }
  }
  fileLoc
}
