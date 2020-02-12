async execute<ReturnT, SourceEventT>(
    program: (event: SourceEventT) => ReturnT,
    sourceEvent: SourceEventT,
  ) : Promise<ReturnT | string | Error> {
    if (await this.warmer.check(<any> sourceEvent)) return 'warmed';

    try {
      const response = await program(unifiedEvent);
      await this.zeebeResponseMiddleware(response);
      return response;
    } catch (err) {
      this.logger.logException(err);
      throw err;
    } finally {
      await this.logger.close();
    }
}
