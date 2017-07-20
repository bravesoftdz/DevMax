unit DevMax.Types;

interface

uses
  System.SysUtils,
  DevMax.Types.ViewInfo;

type
  IManifestService = interface
    ['{37F598CA-9EF4-4CC2-91DF-6444B526BA38}']
    function TryGetViewInfo(AViewId: string; out ViewInfo: TViewInfo): Boolean;
  end;

  IManifestDAO = interface
    ['{37F598CA-9EF4-4CC2-91DF-6444B526BA38}']
    function TryGetViewInfo(AViewId: string; out ViewInfo: TViewInfo): Boolean;
  end;

  IDataAccessService = interface
    ['{16FB2C24-9511-4034-8570-011DF2FD6CDF}']
  end;

  IDataAccessAdapter = interface;
  IDataAccessApi = interface;
  IDataAccessParser = interface;

  /// ���� �����͸� �������� ��ü
  IDataAccessObject = interface
    ['{77AE8F89-E92A-4522-BF4C-48D1BEF4CA91}']
    function GetDataAccessAdapter: IDataAccessAdapter;
    property DataAccessAdapter: IDataAccessAdapter read GetDataAccessAdapter;
  end;

  /// �����Ϳ����� ��� ����
  IDataAccessAdapter = interface
    ['{060D8CED-4E9F-48BB-9865-07AFA477BBAC}']
  end;

  /// ������ ���� API ����
  IDataAccessApi = interface

  end;

  // ���� ������ �м�/��ȯ ����
  IDataAccessParser = interface

  end;

implementation

end.
