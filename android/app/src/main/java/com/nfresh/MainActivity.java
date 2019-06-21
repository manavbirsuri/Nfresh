package com.nfresh;

import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.RequiresApi;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.paytm.pgsdk.PaytmOrder;
import com.paytm.pgsdk.PaytmPGService;
import com.paytm.pgsdk.PaytmPaymentTransactionCallback;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Set;
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
               paytmPayment(call.method, result);
              } catch (Exception e) {
                e.printStackTrace();
              }
             // result.success(greetings);
            });
  }


  private void paytmPayment(String checksumData, MethodChannel.Result result) throws Exception {
    PaytmPGService Service = PaytmPGService.getStagingService();
    PaytmOrder Order = new PaytmOrder(getMapData(checksumData));
    Service.initialize(Order, null);
    Service.startPaymentTransaction(this, true, true, new PaytmPaymentTransactionCallback() {
      /*Call Backs*/
      public void someUIErrorOccurred(String inErrorMessage) {}
      public void onTransactionResponse(Bundle inResponse) {
        Log.i("SUCCESS: ", inResponse.toString());
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
          result.success(getBundleResult(inResponse));
        }else {
          result.success("BELOW KITKAT NOT SUPPORTED");
        }
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
  }

  @RequiresApi(api = Build.VERSION_CODES.KITKAT)
  private String getBundleResult(Bundle bundle) {
    JSONObject json = new JSONObject();
    Set<String> keys = bundle.keySet();
    for (String key : keys) {
      try {
        // json.put(key, bundle.get(key)); see edit below
        json.put(key, JSONObject.wrap(bundle.get(key)));
      } catch(JSONException e) {
        //Handle exception here
      }
    }
    return json.toString();
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
