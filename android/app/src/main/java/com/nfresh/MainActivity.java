package com.nfresh;

import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.util.Log;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.paytm.pgsdk.PaytmOrder;
import com.paytm.pgsdk.PaytmPGService;
import com.paytm.pgsdk.PaytmPaymentTransactionCallback;

import java.util.HashMap;
import java.util.TreeMap;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "flutter.native/helper";
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    if (ContextCompat.checkSelfPermission(MainActivity.this, Manifest.permission.READ_SMS) != PackageManager.PERMISSION_GRANTED) {
      ActivityCompat.requestPermissions(MainActivity.this, new String[]{Manifest.permission.READ_SMS, Manifest.permission.RECEIVE_SMS}, 101);
    }

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            (call, result) -> {
              String greetings = null;
              try {
                greetings = paytmPayment();
              } catch (Exception e) {
                e.printStackTrace();
              }
              result.success(greetings);
            });
  }


  private String paytmPayment() throws Exception {
    PaytmPGService Service = PaytmPGService.getStagingService();

    HashMap<String, String> paramMap = new HashMap<String,String>();
    paramMap.put( "MID" , "apXePW28170154069075");
// Key in your staging and production MID available in your dashboard
    paramMap.put( "ORDER_ID" , "order1");
    paramMap.put( "CUST_ID" , "cust123");
    paramMap.put( "MOBILE_NO" , "7777777777");
    paramMap.put( "EMAIL" , "username@emailprovider.com");
    paramMap.put( "CHANNEL_ID" , "WAP");
    paramMap.put( "TXN_AMOUNT" , "100.12");
    paramMap.put( "WEBSITE" , "WEBSTAGING");
// This is the staging value. Production value is available in your dashboard
    paramMap.put( "INDUSTRY_TYPE_ID" , "Retail");
// This is the staging value. Production value is available in your dashboard
    paramMap.put( "CALLBACK_URL", "https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=order1");
    TreeMap<String, String> treeMap = new TreeMap<String,String>();
    treeMap.put( "MID" , "rxazcv89315285244163");
// Key in your staging and production MID available in your dashboard
    treeMap.put( "ORDER_ID" , "order1");
    treeMap.put( "CUST_ID" , "cust123");
    treeMap.put( "MOBILE_NO" , "7777777777");
    treeMap.put( "EMAIL" , "username@emailprovider.com");
    treeMap.put( "CHANNEL_ID" , "WAP");
    treeMap.put( "TXN_AMOUNT" , "100.12");
    treeMap.put( "WEBSITE" , "WEBSTAGING");
// This is the staging value. Production value is available in your dashboard
    treeMap.put( "INDUSTRY_TYPE_ID" , "Retail");
// This is the staging value. Production value is available in your dashboard
    treeMap.put( "CALLBACK_URL", "https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=order1");
   // String paytmChecksum =  CheckSumServiceHelper.getCheckSumServiceHelper().genrateCheckSum("apXePW28170154069075", treeMap);
    paramMap.put( "CHECKSUMHASH" , "kjhdf89293434bn3n4");
    PaytmOrder Order = new PaytmOrder(paramMap);
    Service.initialize(Order, null);
    Service.startPaymentTransaction(this, true, true, new PaytmPaymentTransactionCallback() {
      /*Call Backs*/
      public void someUIErrorOccurred(String inErrorMessage) {}
      public void onTransactionResponse(Bundle inResponse) {
        Log.i("SUCCESS: ", inResponse.toString());
      }
      public void networkNotAvailable() {}
      public void clientAuthenticationFailed(String inErrorMessage) {
        Log.i("AUTH FAIL: ", inErrorMessage);
      }
      public void onErrorLoadingWebPage(int iniErrorCode, String inErrorMessage, String inFailingUrl) {

      }
      public void onBackPressedCancelTransaction() {

      }
      public void onTransactionCancel(String inErrorMessage, Bundle inResponse) {

      }
    });
    return "PAYTM";
  }
}
