export const appConfig = {
  name: process.env.APP_NAME ?? 'fras-tmdt-be',
  port: Number(process.env.PORT ?? 3000),
  nodeEnv: process.env.NODE_ENV ?? 'development',
};
