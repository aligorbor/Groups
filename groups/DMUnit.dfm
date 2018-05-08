object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 420
  Width = 538
  object connectGroups: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=12345678;Persist Security Info=True' +
      ';User ID=sa;Initial Catalog=Groups;Data Source=IGOR-PC\SQLEXPRES' +
      'S;Use Procedure for Prepare=1;Auto Translate=True;Packet Size=40' +
      '96;Use Encryption for Data=False;Tag with column collation when ' +
      'possible=False'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 56
    Top = 32
  end
  object tGrL: TADOTable
    Connection = connectGroups
    CursorType = ctStatic
    TableName = 'GroupList'
    Left = 384
    Top = 16
  end
  object dsGrL: TDataSource
    DataSet = tGrL
    Left = 424
    Top = 16
  end
  object dsGrChild: TDataSource
    DataSet = tGrChild
    Left = 216
    Top = 72
  end
  object dsUsrL: TDataSource
    DataSet = tUsrL
    Left = 416
    Top = 136
  end
  object tGrChild: TADOTable
    Connection = connectGroups
    CursorType = ctStatic
    LockType = ltReadOnly
    IndexFieldNames = 'ParentID'
    MasterFields = 'GroupID'
    MasterSource = dsGrParent
    TableName = 'GroupTree'
    Left = 160
    Top = 72
    object tGrChildParentID: TIntegerField
      FieldName = 'ParentID'
    end
    object tGrChildGroupID: TIntegerField
      FieldName = 'GroupID'
    end
    object tGrChildname: TStringField
      FieldKind = fkLookup
      FieldName = 'name'
      LookupDataSet = tGrL
      LookupKeyFields = 'GroupID'
      LookupResultField = 'DisplayName'
      KeyFields = 'GroupID'
      ReadOnly = True
      Lookup = True
    end
  end
  object tUsrL: TADOTable
    Connection = connectGroups
    CursorType = ctStatic
    IndexFieldNames = 'UserID'
    TableName = 'UserList'
    Left = 376
    Top = 136
    object tUsrLUserID: TAutoIncField
      FieldName = 'UserID'
      ReadOnly = True
    end
    object tUsrLDisplayName: TWideStringField
      FieldName = 'DisplayName'
      Size = 256
    end
    object tUsrLAccountEnabled: TBooleanField
      FieldName = 'AccountEnabled'
    end
    object tUsrLPhoto: TBlobField
      FieldName = 'Photo'
    end
    object tUsrLPhone: TWideStringField
      FieldName = 'Phone'
      Size = 50
    end
    object tUsrLAddress: TWideStringField
      FieldName = 'Address'
      Size = 100
    end
    object tUsrLNote: TWideStringField
      FieldName = 'Note'
      Size = 256
    end
  end
  object tUsrTr: TADOTable
    Connection = connectGroups
    CursorType = ctStatic
    LockType = ltReadOnly
    IndexFieldNames = 'GroupID'
    MasterFields = 'GroupID'
    MasterSource = dsGrParent
    TableName = 'UserTree'
    Left = 160
    Top = 128
    object tUsrTrGroupID: TIntegerField
      FieldName = 'GroupID'
    end
    object tUsrTrUserID: TIntegerField
      FieldName = 'UserID'
    end
    object tUsrTrname: TStringField
      FieldKind = fkLookup
      FieldName = 'name'
      LookupDataSet = tUsrL
      LookupKeyFields = 'UserID'
      LookupResultField = 'DisplayName'
      KeyFields = 'UserID'
      Lookup = True
    end
    object tUsrTrAccountEnabled: TIntegerField
      FieldKind = fkLookup
      FieldName = 'AccountEnabled'
      LookupDataSet = tUsrLdet
      LookupKeyFields = 'UserID'
      LookupResultField = 'AccountEnabled'
      KeyFields = 'UserID'
      Lookup = True
    end
  end
  object dsUsrTr: TDataSource
    DataSet = tUsrTr
    Left = 208
    Top = 128
  end
  object tGrParent: TADOTable
    Connection = connectGroups
    CursorType = ctStatic
    Filter = 'ParentID = 0'
    Filtered = True
    LockType = ltReadOnly
    AfterScroll = tGrParentAfterScroll
    TableName = 'GroupTree'
    Left = 160
    Top = 16
    object tGrParentParentID: TIntegerField
      FieldName = 'ParentID'
    end
    object tGrParentGroupID: TIntegerField
      FieldName = 'GroupID'
    end
    object tGrParentname: TStringField
      FieldKind = fkLookup
      FieldName = 'name'
      LookupDataSet = tGrL
      LookupKeyFields = 'GroupID'
      LookupResultField = 'DisplayName'
      KeyFields = 'GroupID'
      Lookup = True
    end
  end
  object dsGrParent: TDataSource
    DataSet = tGrParent
    Left = 216
    Top = 16
  end
  object tUsrLdet: TADOTable
    Connection = connectGroups
    CursorType = ctStatic
    BeforeInsert = tUsrLdetBeforeInsert
    AfterPost = tUsrLdetAfterPost
    AfterCancel = tUsrLdetAfterCancel
    AfterScroll = tUsrLdetAfterScroll
    IndexFieldNames = 'UserID'
    MasterFields = 'UserID'
    MasterSource = dsUsrTr
    TableName = 'UserList'
    Left = 264
    Top = 128
    object AutoIncField1: TAutoIncField
      FieldName = 'UserID'
      ReadOnly = True
    end
    object WideStringField1: TWideStringField
      FieldName = 'DisplayName'
      Size = 256
    end
    object BooleanField1: TBooleanField
      DefaultExpression = '0'
      FieldName = 'AccountEnabled'
    end
    object BlobField1: TBlobField
      FieldName = 'Photo'
    end
    object WideStringField2: TWideStringField
      FieldName = 'Phone'
      Size = 50
    end
    object WideStringField3: TWideStringField
      FieldName = 'Address'
      Size = 100
    end
    object WideStringField4: TWideStringField
      FieldName = 'Note'
      Size = 256
    end
  end
  object dsUsrLdet: TDataSource
    DataSet = tUsrLdet
    Left = 312
    Top = 128
  end
  object tGrLdet: TADOTable
    Connection = connectGroups
    CursorType = ctStatic
    BeforeInsert = tGrLdetBeforeInsert
    AfterPost = tGrLdetAfterPost
    AfterCancel = tGrLdetAfterCancel
    IndexFieldNames = 'GroupID'
    MasterFields = 'GroupID'
    MasterSource = dsGrParent
    TableName = 'GroupList'
    Left = 280
    Top = 16
    object tGrLdetGroupID: TAutoIncField
      FieldName = 'GroupID'
      ReadOnly = True
    end
    object tGrLdetDisplayName: TWideStringField
      FieldName = 'DisplayName'
      Size = 256
    end
  end
  object dsGrLdet: TDataSource
    DataSet = tGrLdet
    Left = 320
    Top = 16
  end
  object qInsertUsrTr: TADOQuery
    Connection = connectGroups
    Parameters = <
      item
        Name = 'GroupID'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = 0
      end
      item
        Name = 'UserID'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = 0
      end>
    SQL.Strings = (
      'insert into [dbo].[UserTree] values (:GroupID, :UserID)')
    Left = 168
    Top = 216
  end
  object qInsertGrTr: TADOQuery
    Connection = connectGroups
    Parameters = <
      item
        Name = 'ParentID'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = 0
      end
      item
        Name = 'GroupID'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = 0
      end>
    SQL.Strings = (
      'insert into [dbo].[GroupTree] values (:ParentID, :GroupID)')
    Left = 232
    Top = 216
  end
  object qDelUsr: TADOQuery
    Connection = connectGroups
    Parameters = <
      item
        Name = 'UserID1'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = 0
      end
      item
        Name = 'UserID2'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = 0
      end>
    SQL.Strings = (
      'DELETE'
      '  FROM [dbo].[UserTree]'
      '  where [UserID] = :UserID1;'
      ''
      'DELETE'
      '  FROM [dbo].[UserList]'
      '  where [UserID] = :UserID2;'
      ''
      '')
    Left = 288
    Top = 216
  end
  object qDelGr: TADOQuery
    Connection = connectGroups
    Parameters = <
      item
        Name = 'GroupID1'
        DataType = ftInteger
        Size = -1
        Value = 0
      end
      item
        Name = 'GroupID2'
        DataType = ftInteger
        Size = -1
        Value = 0
      end>
    SQL.Strings = (
      'delete'
      '  FROM [dbo].[GroupTree] FROM [dbo].[GroupTree] gt'
      '  WHERE gt.[GroupID] = :GroupID1'
      
        '        AND NOT EXISTS (select * from [dbo].[GroupTree] as b whe' +
        're gt.[GroupID]=b.[ParentID])'
      
        #9#9'AND NOT EXISTS (select * from [dbo].[UserTree] as c where gt.[' +
        'GroupID]=c.[GroupID]);'
      '  '
      'delete'
      '  FROM [dbo].[GroupList] from [dbo].[GroupList] gl'
      '  WHERE gl.[GroupID] = :GroupID2'
      
        '        AND NOT EXISTS (select * from [dbo].[GroupTree] as b whe' +
        're gl.[GroupID]=b.[ParentID])'
      
        #9#9'AND NOT EXISTS (select * from [dbo].[UserTree] as c where gl.[' +
        'GroupID]=c.[GroupID]);')
    Left = 344
    Top = 216
  end
  object qIs_Empty_Gr: TADOQuery
    Connection = connectGroups
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'GroupID1'
        DataType = ftInteger
        Size = -1
        Value = 0
      end
      item
        Name = 'GroupID2'
        DataType = ftInteger
        Size = -1
        Value = 0
      end>
    SQL.Strings = (
      
        'select count(*) + (select count(*) from [dbo].[UserTree] as c wh' +
        'ere c.[GroupID] = :GroupID1) as is_empty'
      ' from [dbo].[GroupTree] as b where b.[ParentID] = :GroupID2;')
    Left = 400
    Top = 216
    object qIs_Empty_Gris_empty: TIntegerField
      FieldName = 'is_empty'
      ReadOnly = True
    end
  end
  object qMoveUsr: TADOQuery
    Connection = connectGroups
    Parameters = <
      item
        Name = 'GroupID'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = 0
      end
      item
        Name = 'UserID'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = 0
      end>
    SQL.Strings = (
      'UPDATE [dbo].[UserTree] SET [GroupID] = :GroupID'
      'WHERE [UserID] = :UserID;')
    Left = 160
    Top = 264
  end
  object qMoveGr: TADOQuery
    Connection = connectGroups
    Parameters = <
      item
        Name = 'ParentID'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = 0
      end
      item
        Name = 'GroupID'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = 0
      end>
    SQL.Strings = (
      'UPDATE [dbo].[GroupTree] SET [ParentID] = :ParentID'
      'WHERE [GroupID] = :GroupID;')
    Left = 224
    Top = 264
  end
  object qFindUsr: TADOQuery
    Connection = connectGroups
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'findstr'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 256
        Value = ''
      end>
    SQL.Strings = (
      'SELECT ul.[UserID]'
      '            ,ut.[GroupID]'
      '            ,gt.[ParentID]'
      '           ,ul.[DisplayName]'
      '  FROM [dbo].[UserList] as ul,'
      '            [dbo].[UserTree] as ut,'
      '           [dbo].[GroupTree] as gt'
      
        '  WHERE ul.[UserID] = ut.[UserID] AND ut.[GroupID] = gt.[GroupID' +
        ']'
      '       AND UPPER([DisplayName]) like :findstr;')
    Left = 280
    Top = 264
  end
  object dsFindUsr: TDataSource
    DataSet = qFindUsr
    Left = 320
    Top = 264
  end
  object qFindGr: TADOQuery
    Connection = connectGroups
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'findstr'
        Attributes = [paNullable]
        DataType = ftWideString
        NumericScale = 255
        Precision = 255
        Size = 256
        Value = ''
      end>
    SQL.Strings = (
      'SELECT   gl.[GroupID]'
      '        ,gt.[ParentID]'
      '        ,gl.[DisplayName]'
      'FROM [dbo].[GroupList] as gl,'
      '     [dbo].[GroupTree] as gt'
      'WHERE gl.[GroupID] = gt.[GroupID]'
      '      AND UPPER([DisplayName]) like :findstr;')
    Left = 368
    Top = 264
  end
  object dsFindGr: TDataSource
    DataSet = qFindGr
    Left = 408
    Top = 264
  end
end
