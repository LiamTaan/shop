import request from '@/sheep/request';

const BannerApi = {
  getBannerList: (position) =>
    request({
      url: '/promotion/banner/list',
      method: 'GET',
      params: { position },
      custom: {
        showError: false,
        showLoading: false,
      },
    }),
};

export default BannerApi;
