class ProviderFailure {
  final String message;

  ProviderFailure(this.message);

  @override
  String toString() {
    return this.message;
  }
}
