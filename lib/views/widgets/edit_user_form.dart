import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sigest/views/widgets/popup_window.dart';

import '../../models/user.dart';
import '../styles.dart';
import 'button.dart';
import 'input.dart';

class EditUserFormWidget extends StatefulWidget {
  final bool canChangeEmail;
  final bool canChangePassword;
  final Function onSave;
  final Function onDelete;
  final UserModel user;
  final Map<String, dynamic>? errors;
  bool processing;

  EditUserFormWidget(
      {Key? key,
      required this.canChangePassword,
      required this.canChangeEmail,
      required this.onDelete,
      required this.onSave,
      required this.user, this.errors,
        required this.processing
      })
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditUserFormWidgetState();
}

class _EditUserFormWidgetState extends State<EditUserFormWidget> {
  bool showPasswordFields = false;
  bool saveButtonDisabled = true;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Map<String, TextEditingController> bindControllers = {
    'username': TextEditingController(text: ''),
    'email': TextEditingController(text: ''),
    'old_password': TextEditingController(text: ''),
    'new_password': TextEditingController(text: '')
  };

  @override
  void initState() {
    super.initState();
    bindControllers['username']?.text = widget.user.username;
    bindControllers['email']?.text = widget.user.email;
  }

  Widget _renderEmailField() {
    if (widget.canChangeEmail) {
      return TextFormFieldWidget(
        hintText: 'Почта',
        controller: bindControllers['email'],
        borderColor: ColorStyles.gray,
        rules: 'required|email|max:256',
        errorText: widget.errors != null ? widget.errors!['email'] : null,
        onChanged: (value) {
          if (value != widget.user.email) {
            setState(() {
              saveButtonDisabled = false;
            });
          }
        },
      );
    }

    return const SizedBox.shrink();
  }

  Widget _renderPasswordFields() {
    if (widget.canChangePassword) {
      if (showPasswordFields) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _renderChangePasswordTitle(),
            TextFormFieldWidget(
              hintText: 'Старый пароль',
              controller: bindControllers['old_password'],
              borderColor: ColorStyles.gray,
              obscureText: true,
              type: FieldType.password,
              errorText: widget.errors != null ? widget.errors!['old_password'] : null,
              onChanged: (value) {
                setState(() {
                  saveButtonDisabled = false;
                });
              },
            ),
            TextFormFieldWidget(
              hintText: 'Новый пароль',
              controller: bindControllers['new_password'],
              rules: 'min:8|max:22|password',
              borderColor: ColorStyles.gray,
              obscureText: true,
              type: FieldType.password,
              errorText: widget.errors != null ? widget.errors!['password'] : null,
              onChanged: (value) {
                setState(() {
                  saveButtonDisabled = false;
                });
              },
            ),
          ],
        );
      } else {
        return _renderChangePasswordTitle();
      }
    }
    return const SizedBox.shrink();
  }

  Widget _renderChangePasswordTitle() {
    return TextButton(
      style: ButtonStyle(
          overlayColor: MaterialStateProperty.all<Color?>(Colors.transparent),
          minimumSize:
              MaterialStateProperty.all<Size>(const Size(double.infinity, 30)),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.all(0)),
          alignment: AlignmentDirectional.centerStart),
      onPressed: () => setState(() {
        showPasswordFields = !showPasswordFields;
      }),
      child: Text('ИЗМЕНЕНИЕ ПАРОЛЯ',
          style: Theme.of(context).textTheme.bodyMedium),
    );
  }

  Future<void> _renderDeleteDialog() async {
    print('render delete dialog');
    await showDialog<void>(
        context: context,
        builder: (context) {
          return PopupWindowWidget(
            title: 'Удаление профиля',
            text:
                'Вы уверены, что хотите удалить профиль? Все данные будут утеряны',
            onAcceptButtonPress: () { Navigator.pop(context); widget.onDelete();},
            onRejectButtonPress: () => Navigator.pop(context),
            acceptButtonText: 'удалить',
            rejectButtonText: 'отмена',
          );
        });
  }

  Widget _renderButtons() {
    if (widget.processing) {
      return const Padding(
          padding: EdgeInsets.only(
            top: 44,
          ),
          child: CircularProgressIndicator(color: ColorStyles.white));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 14, top: 5),
          child: ButtonWidget(
            onClick: () {
              if (!saveButtonDisabled &&
                  formKey.currentState!.validate()) {
                widget.onSave(bindControllers);
              }
            },
            color: Colors.white,
            backgroundColor: saveButtonDisabled
                ? ColorStyles.gray
                : ColorStyles.green,
            minWidth: 127,
            height: 40,
            text: 'сохранить',
          ),
        ),
        ButtonWidget(
          onClick: () => _renderDeleteDialog(),
          color: Colors.white,
          backgroundColor: Colors.transparent,
          borderSideColor: ColorStyles.red,
          minWidth: 40,
          height: 40,
          borderRadius: 8,
          leadingIcon: const Icon(Icons.delete_outline,
              color: ColorStyles.red, size: 25),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(bottom: 22),
        decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(color: ColorStyles.gray, width: 2.0)),
        ),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormFieldWidget(
                hintText: 'Имя пользователя',
                controller: bindControllers['username'],
                rules: 'required|username|min:1|max:256',
                errorText: widget.errors != null ? widget.errors!['username'] : null,
                borderColor: ColorStyles.gray,
                onChanged: (value) {
                  if (value != widget.user.email) {
                    setState(() {
                      saveButtonDisabled = false;
                    });
                  }
                },
              ),
              _renderEmailField(),
              _renderPasswordFields(),
              _renderButtons(),
            ],
          ),
        ));
  }
}
