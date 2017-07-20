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

  /// 실제 데이터를 가져오는 객체
  IDataAccessObject = interface
    ['{77AE8F89-E92A-4522-BF4C-48D1BEF4CA91}']
    function GetDataAccessAdapter: IDataAccessAdapter;
    property DataAccessAdapter: IDataAccessAdapter read GetDataAccessAdapter;
  end;

  /// 데이터엑세스 기술 정의
  IDataAccessAdapter = interface
    ['{060D8CED-4E9F-48BB-9865-07AFA477BBAC}']
  end;

  /// 연동할 서비스 API 정의
  IDataAccessApi = interface

  end;

  // 수신 데이터 분석/전환 정의
  IDataAccessParser = interface

  end;

implementation

end.
