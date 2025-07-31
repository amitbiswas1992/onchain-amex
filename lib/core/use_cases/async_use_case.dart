abstract class AsyncUseCase<Type, Params> {
  Future<Type> execute(Params param);
}