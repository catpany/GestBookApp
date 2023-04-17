import 'package:injectable/injectable.dart';
import 'package:sigest/api/abstract_api.dart';
import 'package:sigest/api/params.dart';
import 'package:sigest/api/response.dart';

@dev
@LazySingleton(as: AbstractApi)
class ApiMock implements AbstractApi {
  @override
  Future<Response> login(Params params) async {
    const body = {
      'data': {
        'access_token':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwiaWQiOiIxIiwiaWF0IjoxNTE2MjM5MDIyfQ.NdmXS9NOiE6j8T1wcPMR_75r5FLrGmjdSoPZN-smTsU',
        'refresh_token': {
          'token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwiaWQiOiIxIiwiaWF0IjoxNTE2MjM0ODk3fQ.ddM2LN2IFHdlq3OYbXeWrBH40etmiyoug8TGpEbr0Dw',
          'family': 'lhshdfkjshdfkjshdfkjsdhfkjd'
        }
      }
    };

    return Future<Response>.delayed(const Duration(seconds: 2), () {
      return SuccessResponse(data: body);
    });
  }

  @override
  Future<Response> register(Params params) async {
    return Future<Response>.delayed(const Duration(seconds: 2), () {
      return SuccessResponse(data: {});
    });
  }

  @override
  Future<Response> forgotPassword(Params params) async {
    const body = {
      'data': {
        'code': 456122,
      }
    };

    return Future<Response>.delayed(const Duration(seconds: 2), () {
      return SuccessResponse(data: body);
    });
  }

  @override
  Future<Response> resetPassword(Params params) async {
    return Future<Response>.delayed(const Duration(seconds: 2), () {
      return SuccessResponse(data: {});
    });
  }

  @override
  Future<Response> activateProfile(Params params) async {
    return Future<Response>.delayed(const Duration(seconds: 2), () {
      return SuccessResponse(data: {});
    });
  }

  @override
  Future<Response> user(String id) async {
    const body = {
      'data': {'id': 'jhdfj', 'username': 'user N', 'email': 'aaa@mail.ru'}
    };

    // return Future<Response>.delayed(const Duration(seconds: 1), () {
    //   return ErrorResponse(code: 101, message: 'Error');
    // });

    return Future<Response>.delayed(const Duration(seconds: 1), () {
      return SuccessResponse(data: body['data']);
    });
  }

  @override
  Future<Response> units() async {
    const body = {
      'data': {
        'units': [
          {
            'id': 'unit-1',
            'order': 1,
            'lessons': [
              {
                'id': 'lesson-1-1',
                'order': 1,
                'name': 'новый1',
                'progress': 0.1,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 4,
                'theory': true,
              },
              {
                'id': 'lesson-1-2',
                'order': 2,
                'name': 'животные',
                'progress': 0.2,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 4,
                'theory': true,
              },
              {
                'id': 'lesson-1-3',
                'order': 3,
                'name': 'работа',
                'progress': 0.0,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 4,
                'theory': false,
              },
              {
                'id': 'lesson-1-4',
                'order': 4,
                'name': 'природа',
                'progress': 0.6,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 5,
                'theory': false,
              },
              {
                'id': 'lesson-1-5',
                'order': 5,
                'name': 'одежда',
                'progress': 0.0,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 0,
                'theory': true,
              },
              {
                'id': 'lesson-1-6',
                'order': 6,
                'name': 'семья',
                'progress': 0.1,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 0,
                'theory': false,
              },
              {
                'id': 'lesson-1-7',
                'order': 7,
                'name': 'животные',
                'progress': 0.2,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 0,
                'theory': true,
              },
              {
                'id': 'lesson-1-8',
                'order': 8,
                'name': 'работа',
                'progress': 0.0,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 5,
                'theory': true,
              },
              {
                'id': 'lesson-1-9',
                'order': 9,
                'name': 'природа',
                'progress': 0.6,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 5,
                'theory': false,
              },
              {
                'id': 'lesson-1-10',
                'order': 10,
                'name': 'одежда',
                'progress': 0.0,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 0,
                'theory': true,
              },
              {
                'id': 'lesson-1-11',
                'order': 11,
                'name': 'семья',
                'progress': 0.1,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 2,
                'theory': true,
              },
              {
                'id': 'lesson-1-12',
                'order': 12,
                'name': 'животные',
                'progress': 0.2,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 2,
                'theory': true,
              },
              {
                'id': 'lesson-1-13',
                'order': 13,
                'name': 'работа',
                'progress': 0.0,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 2,
                'theory': true,
              },
              {
                'id': 'lesson-1-14',
                'order': 14,
                'name': 'природа',
                'progress': 0.6,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 2,
                'theory': true,
              },
              {
                'id': 'lesson-1-15',
                'order': 15,
                'name': 'одежда',
                'progress': 0.0,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 2,
                'theory': true,
              },
            ]
          },
          {
            'id': 'unit-2',
            'order': 2,
            'lessons': [
              {
                'id': 'lesson-2-1',
                'order': 2,
                'name': 'хобби',
                'progress': 0.1,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 2,
                'theory': true,
              },
              {
                'id': 'lesson-2-2',
                'order': 2,
                'name': 'фильмы',
                'progress': 0.2,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 2,
                'theory': true,
              },
              {
                'id': 'lesson-2-3',
                'order': 3,
                'name': 'невский',
                'progress': 0.0,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 2,
                'theory': true,
              },
              {
                'id': 'lesson-2-4',
                'order': 4,
                'name': 'гачи',
                'progress': 0.5,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 2,
                'theory': true,
              },
              {
                'id': 'lesson-2-5',
                'order': 5,
                'name': 'глаголы',
                'progress': 1.0,
                'icon': 0xf036b,
                'levels_total': 5,
                'levels_finished': 2,
                'theory': true,
              },
            ]
          }
        ]
      },
    };

    return Future<Response>.delayed(const Duration(seconds: 1), () {
      return SuccessResponse(data: body['data']);
    });

    return Future<Response>.delayed(const Duration(seconds: 1), () {
      return ErrorResponse(code: 101, message: 'Error');
    });
  }
}