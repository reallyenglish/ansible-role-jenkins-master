import jenkins.model.*

def plugins = jenkins.model.Jenkins.instance.getPluginManager().getPlugins()


def Jenkins jenkins_instance = Jenkins.getInstance()

def thin

plugins.each {
  println it
  if (it.shortName == "thinBackup")
  {
  thin = it.getPlugin()
  }
}

println ""

// println thin.getFullBackupSchedule()
println "before"
println thin.fullBackupSchedule

thin.fullBackupSchedule = "H 0 * * 1-5"
println "after"
println thin.fullBackupSchedule
println ""

println thin.metaClass.methods*.name.sort().unique()

// [configure, doCheckBackupPath, doCheckBackupSchedule, doCheckExcludedFilesRegex, doCheckForceQuietModeTimeout, doCheckWaitForIdle, doDynamic, equals, getBackupAdditionalFilesRegex, getBackupPath, getClass, getDiffBackupSchedule, getExcludedFilesRegex, getExpandedBackupPath, getForceQuietModeTimeout, getFullBackupSchedule, getHudsonHome, getInstance, getNrMaxStoredFull, getWrapper, hashCode, isBackupAdditionalFiles, isBackupBuildArchive, isBackupBuildResults, isBackupBuildsToKeepOnly, isBackupNextBuildNumber, isBackupPluginArchives, isBackupUserContents, isCleanupDiff, isMoveOldBackupsToZipFile, isWaitForIdle, notify, notifyAll, postInitialize, save, setBackupAdditionalFiles, setBackupAdditionalFilesRegex, setBackupBuildArchive, setBackupBuildResults, setBackupBuildsToKeepOnly, setBackupNextBuildNumber, setBackupPath, setBackupPluginArchives, setBackupUserContents, setCleanupDiff, setDiffBackupSchedule, setExcludedFilesRegex, setForceQuietModeTimeout, setFullBackupSchedule, setMoveOldBackupsToZipFile, setNrMaxStoredFull, setNrMaxStoredFullAsString, setServletContext, setWaitForIdle, start, stop, toString, wait]
