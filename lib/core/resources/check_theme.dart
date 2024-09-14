
import 'package:flutter/material.dart';
import 'package:freelancerApp/core/resources/colors.dart';
import 'package:get_storage/get_storage.dart';

import 'app_assets.dart';


class CheckTheme {


  CheckTheme(){

    final box=GetStorage();
    bool isDarkMode = box.read('theme')??false ;

    print("is=========$isDarkMode");
    if(isDarkMode==true){
      kDrawerText=const Color(0xffFECF3B);
      kShadowColor=Colors.grey[100]!;
      backgroundImage='assets/images/appBackDark.png';
      logo='assets/images/darkLogo.png';
      menuIcon='assets/images/darkMenu.png';
      kPrimaryColor=const Color(0xffFECF3B);
      kBackgroundColor=Colors.black45;
      kTextPrimaryColor=const Color(0xffFECF3B);
      kTextHelperLightColor=Colors.white;
      kBottomBarColor= Colors.black87;
      newCardColor=Colors.transparent;
      kDropDownColor=Colors.grey[800];
      drawerBg='assets/images/drawerBg.png';
      kCardColor=Colors.grey[900];
      buttonBg='assets/images/darkButton.png';
       moneyPrice='assets/images/moneyDark.png';
       goldPrice='assets/images/goldDark.png';
      gazPrice='assets/images/gazDark.png';
       phoneIcon='assets/images/phoneDark.png';
       newsIcon='assets/images/newsDark.png';
       ballIcon='assets/images/ballDark.png';
      homeDrawer='assets/images/darkHome.png';
       billDrawer='assets/images/notiDark.png';
      priceMoneyDrawer='assets/images/priceDark.png';
      goldDrawer='assets/images/goldDark.png';
       gazDrawer='assets/images/gazDark.png';
       phoneDrawer='assets/images/phoneDark.png';
     newsDrawer='assets/images/newsDark.png';
      ballDrawer='assets/images/ballDark.png';
      convertDrawer='assets/images/convertDark.png';
     darkModeDrawer='assets/images/darkDark.png';
    contactDrawer='assets/images/contact_dark.png';
     share='assets/images/shareDark.png';
      logout='assets/images/logout.png';
      gazAppBar='assets/images/gazAppBar.png';
      priceAppBar='assets/images/priceAppBar.png';
      goldAppBar='assets/images/goldAppBar.png';
      phoneAppBar='assets/images/phoneDarkAppbar.png';
      notiImage='assets/images/phoneDarkAppbar.png';
      phoneCardTextColor= Colors.white;
      newsAppBar= 'assets/images/darkNewsAppBar.png';
      ballAppBar= 'assets/images/ballDarkDrawer.png';
      notiAppBar= 'assets/images/notiDarkDrawer.png';
      notiImage= 'assets/images/notiImageDark.png';
      convertAppBar='assets/images/convertDarkAppBar.png';
      contactAppBar=  'assets/images/darkContact.png';

      drawerBg='assets/images/drawerDarkBg.png';



      kTextConvert=Colors.black;
      kTextHelperDarkColor=Colors.white;
       kBallColor=   const Color(0xffFECF3B);
       kBallColor2=   const Color(0xffEA4335);
      print("IS DARK TRUE.....");
    }

    else{
      print("IS DARK FALSE....");
      kPrimaryColor = const Color(0xff346EA2);
      kShadowColor=Colors.grey[900]!;
       phoneCardTextColor= Colors.black;
       kBackgroundColor = Colors.blue[100];
      kTextPrimaryColor = const Color(0xff346EA2);
     kTextHelperLightColor=Colors.white;
      kDropDownColor=Colors.white;
       kTextHelperDarkColor=Colors.black;


       kTextConvert=Colors.white;
      kBottomBarColor=const Color(0xffDFEBF6);

    backgroundColor = Colors.white;

      kDrawerText = Colors.white;

   appBarColor = Colors.grey[100];
  iconColor = Colors.blue;

    newCardColor=Colors.white;

      kCardColor=const Color(0xffDFEBF6);

       kButtonColor=   const Color(0xff346EA2);

    kBallColor=   const Color(0xff346EA2);
 kBallColor2=   const Color(0xff5E34A2).withOpacity(0.7);
//contactAppBar.png
      contactAppBar=  ' assets/images/contactAppBar.png';
// dynamic kButtonColor=   const Color(0xff346EA2);
// Color(0xffFECF3B),
// Color(0xffEA4335)

       drawerBg='assets/images/drawer_color.png';
      convertAppBar='assets/images/convertAppBar.png';
     backgroundImage='assets/images/appBackground.png';
   menuIcon='assets/images/menu.png';
     logo='assets/images/logo.png';
     buttonBg='assets/images/button.png';



     moneyPrice='assets/images/moneyPrice.png';
   goldPrice='assets/images/goldPrice.png';
       gazPrice='assets/images/gazPrice.png';
   phoneIcon='assets/images/phone2.png';
      newsIcon='assets/images/news.png';
       ballIcon='assets/images/ball.png';


       homeDrawer='assets/images/home.png';
       billDrawer='assets/images/bill.png';
       priceMoneyDrawer='assets/images/priceMoney.png';
     goldDrawer='assets/images/goldMoney.png';
   gazDrawer='assets/images/gaz.png';
    phoneDrawer='assets/images/phoneDrawerIcon.png';
     newsDrawer='assets/images/newsDrawerIcon.png';
      ballDrawer='assets/images/ball.png';
    convertDrawer='assets/images/convert.png';
    darkModeDrawer='assets/images/darkMode.png';
     contactDrawer='assets/images/contact.png';
     share='assets/images/share2.png';
    logout='assets/images/logout.png';


    gazAppBar='assets/images/gazDrawer.png';
    priceAppBar='assets/images/priceDrawer.png';
     goldAppBar='assets/images/goldDrawer.png';

     phoneAppBar= 'assets/images/phoneDrawer.png';
    newsAppBar= 'assets/images/newsDrawer.png';
   ballAppBar= 'assets/images/ballDrawer.png';

   notiAppBar= 'assets/images/notiDrawer.png';
   notiImage= 'assets/images/noti.png';
    }

  }
}