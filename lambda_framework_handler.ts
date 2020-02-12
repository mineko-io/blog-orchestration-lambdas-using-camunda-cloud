const handler = async (request: any): Promise<any> => RuntimeInstance.execute(
    () => 'the actual lambda program',
    request,
);