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

import org.json.JSONException;
import org.json.JSONObject;

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
    /*if (ContextCompat.checkSelfPermission(MainActivity.this, Manifest.permission.READ_SMS) != PackageManager.PERMISSION_GRANTED) {
      ActivityCompat.requestPermissions(MainActivity.this, new String[]{Manifest.permission.READ_SMS, Manifest.permission.RECEIVE_SMS}, 101);
    }*/

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            (call, result) -> {
              String greetings = null;

              try {
                greetings = paytmPayment(call.method);
              } catch (Exception e) {
                e.printStackTrace();
              }
              result.success(greetings);
            });
  }


  private String paytmPayment(String checksumData) throws Exception {
    PaytmPGService Service = PaytmPGService.getStagingService();
    PaytmOrder Order = new PaytmOrder(getMapData(checksumData));
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

  HashMap<String, String> getMapData(String checksumData) throws JSONException {

    String[] data = checksumData.split("::");
    String checksum = data[0];
    String json = data[1];
    Log.i("DATA: ", json);
    JSONObject payData = new JSONObject(json);
    HashMap<String, String> paramMap = new HashMap<>();
    paramMap.put( "MID" , payData.getString("MID"));
// Key in your staging and production MID available in your dashboard
    paramMap.put( "ORDER_ID" , payData.getString("ORDER_ID"));
    paramMap.put( "CUST_ID" , payData.getString("CUST_ID"));
    paramMap.put( "MOBILE_NO" , payData.getString("MOBILE_NO"));
    paramMap.put( "EMAIL" ,payData.getString("EMAIL"));
    paramMap.put( "CHANNEL_ID" , payData.getString("CHANNEL_ID"));
    paramMap.put( "TXN_AMOUNT" ,payData.getString("TXN_AMOUNT"));
    paramMap.put( "WEBSITE" , payData.getString("WEBSITE"));
// This is the staging value. Production value is available in your dashboard
    paramMap.put( "INDUSTRY_TYPE_ID" , payData.getString("INDUSTRY_TYPE_ID"));
// This is the staging value. Production value is available in your dashboard
    paramMap.put( "CALLBACK_URL", payData.getString("CALLBACK_URL"));
    // String paytmChecksum =  CheckSumServiceHelper.getCheckSumServiceHelper().genrateCheckSum("apXePW28170154069075", treeMap);
    paramMap.put( "CHECKSUMHASH" , checksum);
    return paramMap;
  }
}
