abstract class SyncUseCase <Type, Param> {
  Type execute(Param param);
}