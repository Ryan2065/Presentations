SELECT [TaskID]
      ,CONVERT
      (
        VARCHAR(MAX),
        CAST('' AS XML).value('xs:base64Binary(sql:column("ClientNotificationMessage"))', 'VARBINARY(MAX)')
      ) 'ClientNotificationMessage'
      ,[ScriptGuid]
      ,[ScriptName]
      ,[ScriptVersion]
      ,[Feature]
      ,[ClientOperationId]
      ,[CollectionId]
      ,[TotalClients]
      ,[LastUpdateTime]
      ,[OverallScriptExecutionState]
      ,[OfflineClients]
      ,[UnknownClients]
      ,[NotApplicableClients]
      ,[FailedClients]
      ,[CompletedClients]
  FROM [CM_PS1].[dbo].[vSMS_ScriptsExecutionTask]