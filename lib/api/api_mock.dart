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
          'token':
              'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwiaWQiOiIxIiwiaWF0IjoxNTE2MjM0ODk3fQ.ddM2LN2IFHdlq3OYbXeWrBH40etmiyoug8TGpEbr0Dw',
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
  Future<Response> sendCode(Params params) async {
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
    const body = {
      'data': {
        'access_token':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwiaWQiOiIxIiwiaWF0IjoxNTE2MjM5MDIyfQ.NdmXS9NOiE6j8T1wcPMR_75r5FLrGmjdSoPZN-smTsU',
        'refresh_token': {
          'token':
              'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwiaWQiOiIxIiwiaWF0IjoxNTE2MjM0ODk3fQ.ddM2LN2IFHdlq3OYbXeWrBH40etmiyoug8TGpEbr0Dw',
          'family': 'lhshdfkjshdfkjshdfkjsdhfkjd'
        }
      }
    };

    return Future<Response>.delayed(const Duration(seconds: 2), () {
      return SuccessResponse(data: body);
    });
  }

  @override
  Future<Response> activateProfile(Params params) async {
    const body = {
      'data': {
        'access_token':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwiaWQiOiIxIiwiaWF0IjoxNTE2MjM5MDIyfQ.NdmXS9NOiE6j8T1wcPMR_75r5FLrGmjdSoPZN-smTsU',
        'refresh_token': {
          'token':
              'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwiaWQiOiIxIiwiaWF0IjoxNTE2MjM0ODk3fQ.ddM2LN2IFHdlq3OYbXeWrBH40etmiyoug8TGpEbr0Dw',
          'family': 'lhshdfkjshdfkjshdfkjsdhfkjd'
        }
      }
    };

    return Future<Response>.delayed(const Duration(seconds: 2), () {
      return SuccessResponse(data: body);
    });
  }

  @override
  Future<Response> user() async {
    const body = {
      'data': {
        'id': 'jhdfj',
        'username': 'userN',
        'email': 'aaa@mail.ru',
        'stat': {
          'impact_mode': 0,
          'goal': 30,
          'goal_achieved': 12,
          'lessons_total': 1
        }
      }
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
        'list': [
          {
            'id': 'unit-1',
            'order': 1,
            'lessons': [
              {
                'id': 'lesson-1-1',
                'order': 1,
                'name': 'новый1',
                'progress': 0.1,
                'icon': "0xf036b",
                'levels_total': 5,
                'levels_finished': 4,
                'theory': true,
              },
              {
                'id': 'lesson-1-2',
                'order': 2,
                'name': 'животные',
                'progress': 0.2,
                'icon': "0xf036b",
                'levels_total': 5,
                'levels_finished': 4,
                'theory': true,
              },
              {
                'id': 'lesson-1-3',
                'order': 3,
                'name': 'работа',
                'progress': 0.0,
                'icon': "0xf036b",
                'levels_total': 5,
                'levels_finished': 4,
                'theory': false,
              },
              {
                'id': 'lesson-1-4',
                'order': 4,
                'name': 'природа',
                'progress': 0.6,
                'icon': "0xf036b",
                'levels_total': 5,
                'levels_finished': 5,
                'theory': false,
              },
              {
                'id': 'lesson-1-5',
                'order': 5,
                'name': 'одежда',
                'progress': 0.0,
                'icon': "0xf036b",
                'levels_total': 5,
                'levels_finished': 0,
                'theory': true,
              },
              {
                'id': 'lesson-1-6',
                'order': 6,
                'name': 'семья',
                'progress': 0.1,
                'icon': "0xf036b",
                'levels_total': 5,
                'levels_finished': 0,
                'theory': false,
              },
              {
                'id': 'lesson-1-7',
                'order': 7,
                'name': 'животные',
                'progress': 0.2,
                'icon': "0xf036b",
                'levels_total': 5,
                'levels_finished': 0,
                'theory': true,
              },
              {
                'id': 'lesson-1-8',
                'order': 8,
                'name': 'работа',
                'progress': 0.0,
                'icon': "0xf036b",
                'levels_total': 5,
                'levels_finished': 5,
                'theory': true,
              },
              {
                'id': 'lesson-1-9',
                'order': 9,
                'name': 'природа',
                'progress': 0.6,
                'icon': "0xf036b",
                'levels_total': 5,
                'levels_finished': 5,
                'theory': false,
              },
              {
                'id': 'lesson-1-10',
                'order': 10,
                'name': 'одежда',
                'progress': 0.0,
                'icon': "0xf036b",
                'levels_total': 5,
                'levels_finished': 0,
                'theory': true,
              },
              {
                'id': 'lesson-1-11',
                'order': 11,
                'name': 'семья',
                'progress': 0.1,
                'icon': "0xf036b",
                'levels_total': 5,
                'levels_finished': 2,
                'theory': true,
              },
              {
                'id': 'lesson-1-12',
                'order': 12,
                'name': 'животные',
                'progress': 0.2,
                'icon': "0xf036b",
                'levels_total': 5,
                'levels_finished': 2,
                'theory': true,
              },
              {
                'id': 'lesson-1-13',
                'order': 13,
                'name': 'работа',
                'progress': 0.0,
                'icon': "0xf036b",
                'levels_total': 5,
                'levels_finished': 2,
                'theory': true,
              },
              {
                'id': 'lesson-1-14',
                'order': 14,
                'name': 'природа',
                'progress': 0.6,
                'icon': "0xf036b",
                'levels_total': 5,
                'levels_finished': 2,
                'theory': true,
              },
              {
                'id': 'lesson-1-15',
                'order': 15,
                'name': 'одежда',
                'progress': 0.0,
                'icon': "0xf036b",
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
                'icon': "0xf036b",
                'levels_total': 5,
                'levels_finished': 2,
                'theory': true,
              },
              {
                'id': 'lesson-2-2',
                'order': 2,
                'name': 'фильмы',
                'progress': 0.2,
                'icon': "0xf036b",
                'levels_total': 5,
                'levels_finished': 2,
                'theory': true,
              },
              {
                'id': 'lesson-2-3',
                'order': 3,
                'name': 'невский',
                'progress': 0.0,
                'icon': "0xf036b",
                'levels_total': 5,
                'levels_finished': 2,
                'theory': true,
              },
              {
                'id': 'lesson-2-4',
                'order': 4,
                'name': 'гачи',
                'progress': 0.5,
                'icon': "0xf036b",
                'levels_total': 5,
                'levels_finished': 2,
                'theory': true,
              },
              {
                'id': 'lesson-2-5',
                'order': 5,
                'name': 'глаголы',
                'progress': 1.0,
                'icon': "0xf036b",
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

  @override
  Future<Response> updateUser(Params params) async {
    const body = {
      'data': {
        'id': '917e13a3-ac72-4d7e-ac85-25fb4c45fda4',
        'username': 'alice74',
        'email': 'mraz.gerhard@example.org',
        'role': 'user'
      }
    };

    return Future<Response>.delayed(const Duration(seconds: 2), () {
      return SuccessResponse(data: body);
    });
  }

  @override
  Future<Response> deleteUser() async {
    return Future<Response>.delayed(const Duration(seconds: 2), () {
      return SuccessResponse(data: {});
    });
  }

  @override
  Future<Response> authViaGoogle() {
    const body = {
      'data': {
        'link':
            'https://accounts.google.com/o/oauth2/v2/auth?response_type=code&access_type=online&client_id=571118360099-0ktjk6evriu08tvsto5g7nff7tj75bg5.apps.googleusercontent.com&redirect_uri=http%3A%2F%2Flocalhost%3A8000%2Fapi%2Fauth%2Flogin%2Fgoogle&state=52136c87877c55e284f91b97588af5d6&scope=openid%20email&prompt=select_account'
      }
    };

    return Future<Response>.delayed(const Duration(seconds: 2), () {
      return SuccessResponse(data: body['data']);
    });
  }

  @override
  Future<Response> authViaVK() {
    const body = {
      'data': {
        'link':
            'https://oauth.vk.com/authorize?client_id=51557636&redirect_uri=http%3A%2F%2Flocalhost%3A8000%2Fapi%2Fv1%2Fauth%2Flogin%2Fvk&display=mobile&scope=4194304&state=52136c87877c55e284f91b97588af5d6&response_type=code&v=5.101'
      }
    };

    return Future<Response>.delayed(const Duration(seconds: 2), () {
      return SuccessResponse(data: body['data']);
    });
  }

  @override
  Future<Response> search(Params params) {
    const body = {
      "data": [
        {
          "id": "6c32520c-43be-4c88-bbc3-12325d1b539c",
          "name": "Dr.",
          "context": "Mr.",
          "gesture": "70cc2bd4-9246-4913-8fc5-c140329a6eab"
        },
        {
          "id": "e805700c-37a3-4458-a079-e4e96bea917d",
          "name": "Dr.",
          "context": "Prof.",
          "gesture": "0d0801b3-b40c-4ed9-bc45-542fe72d0d32"
        },
        {
          "id": "ff940e61-a8e0-4e5e-91cf-5f06ddf68886",
          "name": "Dr.",
          "context": "Prof.",
          "gesture": "b57661f4-575e-41bd-a699-1555ab103542"
        },
        {
          "id": "5909efeb-af5f-4356-a84a-687123009a57",
          "name": "Dr.",
          "context": "Miss",
          "gesture": "88da2cb3-5ced-4163-8e25-d35dc05f657c"
        },
        {
          "id": "dece11a9-379e-4275-b275-e4607cd925f2",
          "name": "Dr.",
          "context": "Mr.",
          "gesture": "88da2cb3-5ced-4163-8e25-d35dc05f657c"
        },
        {
          "id": "93b75bcf-6eb5-478b-bb79-759129c87cd1",
          "name": "Dr.",
          "context": "Prof.",
          "gesture": "72781f84-a07a-48c2-9668-5dfb9a63fea1"
        },
        {
          "id": "7556b063-93f3-42f7-a91c-90f9fa37a3bb",
          "name": "Dr.",
          "context": "Miss",
          "gesture": "72781f84-a07a-48c2-9668-5dfb9a63fea1"
        },
        {
          "id": "7d75ff81-289d-40ca-b947-f71192e36625",
          "name": "Dr.",
          "context": "Prof.",
          "gesture": "586e582c-2155-4826-b986-aa50521e479b"
        },
        {
          "id": "4c3f62b5-366e-46bb-9faf-740428bd866d",
          "name": "Dr.",
          "context": "Mr.",
          "gesture": "8e51c964-e156-4639-a6f8-f5d10c4c6404"
        },
        {
          "id": "5883e605-4e55-46bc-bf54-91e50d6d4a30",
          "name": "Dr.",
          "context": "Mr.",
          "gesture": "8808620a-825c-48b5-8d5e-4b4bf576bbe3"
        },
        {
          "id": "5d42b5ef-1fca-45f8-aa95-84d787bc14a1",
          "name": "Dr.",
          "context": "Dr.",
          "gesture": "e5271750-01c0-479e-9751-a8217cef1d50"
        },
        {
          "id": "b107d26f-00b5-4eaa-bbd3-5918c1821a4c",
          "name": "Dr.",
          "context": "Mr.",
          "gesture": "e5271750-01c0-479e-9751-a8217cef1d50"
        },
        {
          "id": "11c7c939-3f0a-418e-9e88-6d5dd5feaa6b",
          "name": "Dr.",
          "context": "Prof.",
          "gesture": "7434f22d-6ec8-4196-9aac-ae45f04e7a41"
        },
        {
          "id": "56e50347-10d7-46ce-b346-0dc30f877eb5",
          "name": "Dr.",
          "context": "Prof.",
          "gesture": "07828ec8-efeb-496e-bebd-65eb3b793659"
        },
        {
          "id": "b9dadf8b-9fc4-4cd1-a999-49f24be30660",
          "name": "Dr.",
          "context": "Dr.",
          "gesture": "07828ec8-efeb-496e-bebd-65eb3b793659"
        },
        {
          "id": "00734668-50c1-4362-8218-6218fb9a8421",
          "name": "Dr.",
          "context": "Mr.",
          "gesture": "e6fdf2a6-93c2-408d-ab56-89cbaf9e0472"
        },
        {
          "id": "a203dda4-d148-4657-b150-469de4eec65e",
          "name": "Dr.",
          "context": "Miss",
          "gesture": "e90f4b45-6ad6-403d-8ad9-9c955e14b029"
        },
        {
          "id": "702f58a2-32c8-49d0-a31a-f9ef55263630",
          "name": "Dr.",
          "context": "Prof.",
          "gesture": "82da7b1f-51b0-4db6-98e3-0424822127a4"
        },
        {
          "id": "c2ed6498-9aaa-4409-8a5e-ac6749a54f27",
          "name": "Dr.",
          "context": "Mr.",
          "gesture": "82da7b1f-51b0-4db6-98e3-0424822127a4"
        },
        {
          "id": "7ab150c8-cf24-47f1-bb63-fe2bb477a36a",
          "name": "Dr.",
          "context": "Prof.",
          "gesture": "d804c800-c1e9-40f3-a6ce-c3c571f686db"
        },
        {
          "id": "17936c5b-cdc2-4f01-b060-cd9debe66dc2",
          "name": "Dr.",
          "context": "Miss",
          "gesture": "f2a520be-24e8-451b-9163-1f4099f15d1b"
        },
        {
          "id": "e45d20b1-13a9-471b-b755-ee0ab53fe15d",
          "name": "Dr.",
          "context": "Miss",
          "gesture": "eab008d8-e5e1-4e37-a0b7-32d9118f7fa5"
        },
        {
          "id": "57edec86-f083-42c7-b09a-87b8b56af20c",
          "name": "Dr.",
          "context": "Prof.",
          "gesture": "8bed1535-7fd4-4539-be61-67f8dda6d474"
        },
        {
          "id": "d8ecc31e-85f7-46ac-a641-a2ba8f2ad5a0",
          "name": "Dr.",
          "context": "Mrs.",
          "gesture": "f243505b-82dc-405f-bdd7-230c99e750a2"
        },
        {
          "id": "006271ce-6652-4f50-82d0-84d69a4d06de",
          "name": "Dr.",
          "context": "Dr.",
          "gesture": "8756db82-b7d2-49b4-8989-1b96c02049ae"
        },
        {
          "id": "7bfb8824-0f0f-4589-9c34-aacfaace4307",
          "name": "Dr.",
          "context": "Miss",
          "gesture": "8756db82-b7d2-49b4-8989-1b96c02049ae"
        },
        {
          "id": "63a5d9a6-8a85-41e8-a43b-f25250cdd21a",
          "name": "Dr.",
          "context": "Ms.",
          "gesture": "8756db82-b7d2-49b4-8989-1b96c02049ae"
        },
        {
          "id": "0e8772c8-15ca-4c12-9321-2a75b10ecc11",
          "name": "Dr.",
          "context": "Mr.",
          "gesture": "ad51c722-4701-479e-b48d-bd900bc621f0"
        },
        {
          "id": "4ae7a9f4-1c28-4067-8956-3afefd1cc67a",
          "name": "Dr.",
          "context": "Ms.",
          "gesture": "228c36ea-1a02-428b-9b80-852d11991634"
        },
        {
          "id": "9910c265-a602-42e4-ac27-89096b4dbe09",
          "name": "Dr.",
          "context": "Prof.",
          "gesture": "70cc2bd4-9246-4913-8fc5-c140329a6eab"
        }
      ]
    };

    // return Future<Response>.delayed(const Duration(seconds: 2), () {
    //   return SuccessResponse(data: [], page: 1, perPage: 30, total: 0);
    // });
    //
    // return Future<Response>.delayed(const Duration(seconds: 1), () {
    //   return ErrorResponse(code: 404, message: 'Error');
    // });

    return Future<Response>.delayed(const Duration(seconds: 2), () {
      return SuccessResponse(
          data: body['data'], page: 1, perPage: 30, total: 30);
    });
  }

  @override
  Future<Response> favorites(Params params) async {
    const body = {
      "data": {
        "id": "6cc50649-74f2-4fb0-a852-0a5f77240b44",
        "gestures": {
          "data": [
            {
              "id": "482ff4ba-ba95-4b22-b0ce-60af1e56222f",
              "name": "гармония",
              "context": ""
            },
            {
              "id": "020ac345-1cca-45a7-9bfb-00762074072b",
              "name": "орбита",
              "context":
                  "Nobis asperiores sed tempore tenetur. A harum suscipit doloremque labore consequatur. Perferendis beatae et alias aperiam. Exercitationem incidunt dicta repellat dolorum et quae."
            },
            {
              "id": "4b028834-fac2-40b0-a28a-bcd3d1f3ab14",
              "name": "помогать",
              "context":
                  "Quaerat dolor unde atque. Provident voluptas fuga autem itaque velit qui tenetur sit. Vero qui optio optio repellat aliquam."
            }
          ],
          "page": 1,
          "per_page": 30,
          "total": 3
        }
      }
    };

    // return Future<Response>.delayed(const Duration(seconds: 2), () {
    //   return SuccessResponse(data: [], page: 1, perPage: 30, total: 0);
    // });

    return Future<Response>.delayed(const Duration(seconds: 2), () {
      return SuccessResponse(
          data: body['data'], page: 1, perPage: 30, total: 1);
    });
  }

  @override
  Future<Response> gesture(String id) async {
    const body = {
      "data": {
        "id": "70cc2bd4-9246-4913-8fc5-c140329a6eab",
        "name": "Гомель",
        "context": "",
        "description":
            "Quia voluptates minima exercitationem nemo pariatur ratione sit id. Fugit aperiam est iusto praesentium eum sapiente. Facere maiores ipsum autem quis inventore molestiae mollitia. Est illum at qui.",
        "src": "http://localhost:8000/storage/gestures/gomel-rsl.mp4",
        "img": null,
        "aud": "user",
        "key_words": [
          {
            "id": "9910c265-a602-42e4-ac27-89096b4dbe09",
            "name": "Dr.",
            "context": "Prof."
          },
          {
            "id": "6c32520c-43be-4c88-bbc3-12325d1b539c",
            "name": "Dr.",
            "context": "Mr."
          },
          {
            "id": "b7bdd295-1518-4c37-a9ad-45adc57aff7b",
            "name": "Ms.",
            "context": "Prof."
          }
        ]
      }
    };

    return Future<Response>.delayed(const Duration(seconds: 2), () {
      return SuccessResponse(data: body['data']);
    });
  }

  @override
  Future<Response> addToFavorites(Params params) {
    return Future<Response>.delayed(const Duration(seconds: 2), () {
      return SuccessResponse(data: {});
    });
  }

  @override
  Future<Response> removeFromFavorites(Params params) {
    return Future<Response>.delayed(const Duration(seconds: 2), () {
      return SuccessResponse(data: {});
    });
  }

  @override
  Future<Response> downloadVideo(String url) {
    return Future<Response>.delayed(const Duration(seconds: 2), () {
      return ErrorResponse(code: 404, message: 'Not Found');
    });
  }

  @override
  Future<Response> downloadImage(String url) {
    return Future<Response>.delayed(const Duration(seconds: 2), () {
      return ErrorResponse(code: 404, message: 'Not Found');
    });
  }

  @override
  Future<Response> searchFavorites(Params params) {
    const body = {
      "data": {
        "id": "6cc50649-74f2-4fb0-a852-0a5f77240b44",
        "gestures": {
          "data": [
            {
              "id": "482ff4ba-ba95-4b22-b0ce-60af1e56222f",
              "name": "гармония",
              "context": ""
            },
            {
              "id": "020ac345-1cca-45a7-9bfb-00762074072b",
              "name": "орбита",
              "context":
              "Nobis asperiores sed tempore tenetur. A harum suscipit doloremque labore consequatur. Perferendis beatae et alias aperiam. Exercitationem incidunt dicta repellat dolorum et quae."
            },
            {
              "id": "4b028834-fac2-40b0-a28a-bcd3d1f3ab14",
              "name": "помогать",
              "context":
              "Quaerat dolor unde atque. Provident voluptas fuga autem itaque velit qui tenetur sit. Vero qui optio optio repellat aliquam."
            }
          ],
          "page": 1,
          "per_page": 30,
          "total": 3
        }
      }
    };

    return Future<Response>.delayed(const Duration(seconds: 2), () {
      return SuccessResponse(data: body['data']);
    });
  }
}
