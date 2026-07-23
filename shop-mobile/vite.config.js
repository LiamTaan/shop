import { loadEnv } from 'vite';
import uni from '@dcloudio/vite-plugin-uni';
import path from 'path';
import fs from 'fs';
// import viteCompression from 'vite-plugin-compression';
import uniReadPagesV3Plugin from './sheep/router/utils/uni-read-pages-v3';

function copyMpWeixinStaticAssets() {
  const sourceDir = path.resolve(__dirname, 'static');

  return {
    name: 'copy-mp-weixin-static-assets',
    writeBundle(outputOptions) {
      const outputDir = outputOptions.dir || '';
      if (!outputDir.replace(/\\/g, '/').endsWith('/mp-weixin')) {
        return;
      }
      const targetDir = path.resolve(outputDir, 'static');
      fs.cpSync(sourceDir, targetDir, { recursive: true, force: true });
    },
  };
}


// https://vitejs.dev/config/
export default (command, mode) => {
  const env = loadEnv(mode, __dirname, 'SHOPRO_');
  const staticAssetsPlugin = copyMpWeixinStaticAssets();
  return {
		envPrefix: "SHOPRO_",
		plugins: [
			uni(),
			staticAssetsPlugin,
			// viteCompression({
			// 	verbose: false
			// }),
			uniReadPagesV3Plugin({
				pagesJsonDir: path.resolve(__dirname, './pages.json'),
				includes: ['path', 'aliasPath', 'name', 'meta'],
			})
		],
		resolve: {
			alias: {
				'@': path.resolve(__dirname),
				sheep: path.resolve(__dirname, './sheep'),
			},
		},
		server: {
			host: true,
			// open: true,
			port: env.SHOPRO_DEV_PORT,
			hmr: {
				overlay: true,
			},
		},
	};
};
