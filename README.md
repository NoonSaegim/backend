# Noonsaegim
https://user-images.githubusercontent.com/64599394/132844018-630ed0bb-5a99-4feb-8d8e-7c5e6af2863f.mp4

눈새김은 사진을 제출하면 객체를 인식하여 영어 단어와 의미를 알려주는 인공지능 앱입니다.

영단어가 궁금한 객체를 즉석에서 바로 사진을 찍거나 사진을 첨부하여 쉽게 검색하고 외울 수 있게 하기 위해서 기획하게 되었습니다.

기본적으로 검출된 데이터에 대한 TTS 서비스를 제공하며
원하는 데이터만 선택해서 개인 단어장에 저장할 수 있고 단어장 개별 항목마다 알림 설정도 가능합니다.

또한 원하는 리스트의 데이터를 WAV, PDF 형식의 파일로 변환해 다운받거나 공유할 수도 있습니다.

(최근 업데이트된 Android 11부터 외부 저장소에 미디어 파일 생성이 허용되지 않아 flutter_tts 플러그인 자체 메서드가 
아닌 다른 방법을 통한 internal audio file conversion 구현 방법을 테스트 중이니 완성하는 대로 다시 업로드 하겠습니다.)

![app_icon](https://user-images.githubusercontent.com/64599394/132732824-1d2eebb9-b05c-401f-a663-e5695a4e6a8e.png)


*한국전자통신연구원의 객체검출 오픈 api와 네이버 파파고 번역 오픈 api 를 통해 구현되었습니다.* 

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
