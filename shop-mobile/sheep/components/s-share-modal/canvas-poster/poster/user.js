import sheep from '@/sheep';
import { formatImageUrlProtocol, getWxaQrcode } from './index';
import { measureTextWidth } from '@/utils/textUtils';

const user = async (poster) => {
  const width = poster.width;
  const userInfo = sheep.$store('user').userInfo;
  const wxaQrcode = await getWxaQrcode(poster.shareInfo.path, poster.shareInfo.query);
  const widthNickName = measureTextWidth(userInfo.nickname, 14);
  const posterItems = [];
  const userBg = sheep.$store('app').platform.share.posterInfo.user_bg;

  if (userBg) {
    posterItems.push({
      type: 'image',
      src: formatImageUrlProtocol(sheep.$url.cdn(userBg)),
      css: {
        width,
        position: 'fixed',
        'object-fit': 'contain',
        top: '0',
        left: '0',
        zIndex: -1,
      },
    });
  }

  posterItems.push(
    {
      type: 'text',
      text: userInfo.nickname,
      css: {
        color: '#333',
        fontSize: 14,
        textAlign: 'center',
        fontFamily: 'sans-serif',
        position: 'fixed',
        top: width * 0.4,
        left: (width - widthNickName) / 2,
      },
    },
    {
      type: 'image',
      src: formatImageUrlProtocol(sheep.$url.cdn(userInfo.avatar)),
      css: {
        position: 'fixed',
        left: width * 0.4,
        top: width * 0.16,
        width: width * 0.2,
        height: width * 0.2,
      },
    },
    // #ifndef MP-WEIXIN
    {
      type: 'qrcode',
      text: poster.shareInfo.link,
      css: {
        position: 'fixed',
        left: width * 0.35,
        top: width * 0.84,
        width: width * 0.3,
        height: width * 0.3,
      },
    },
    // #endif
    // #ifdef MP-WEIXIN
    {
      type: 'image',
      src: wxaQrcode,
      css: {
        position: 'fixed',
        left: width * 0.35,
        top: width * 0.84,
        width: width * 0.3,
        height: width * 0.3,
      },
    },
    // #endif
  );

  return posterItems;
};

export default user;
