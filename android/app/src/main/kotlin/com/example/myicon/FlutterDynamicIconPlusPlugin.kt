package com.example.myicon

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope


/** FlutterDynamicIconPlusPlugin */
class FlutterDynamicIconPlusPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private var activity: Activity? = null

  companion object {
    const val pluginName = "flutter_dynamic_icon_plus"
    const val appIcon = "app_icon"
  }

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, pluginName)
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when(call.method){
      MethodNames.setAlternateIconName -> {
        if(activity != null){
          val sp = activity?.getSharedPreferences(pluginName, Context.MODE_PRIVATE)
          val iconName = call.argument<String?>(Arguments.iconName)
          val brandsInString = call.argument<String?>(Arguments.brands)
          val manufacturesInString = call.argument<String?>(Arguments.manufactures)
          val modelsInString = call.argument<String?>(Arguments.models)

          Log.d("setAlternateIconName", "Icon Name: $iconName with blacklist " +
                  "brands: $brandsInString," +
                  "manufactures: $manufacturesInString," +
                  "models: $modelsInString")

          val saved = sp?.edit()?.putString(appIcon, iconName)?.commit()

          Log.d("setAlternateIconName", "Saved app icon status: $saved")

          if(saved == true){
            if(containsOnBlacklist(brandsInString, manufacturesInString, modelsInString)){
              if(activity != null){
                if(iconName != null){
                  ComponentUtil.changeAppIcon(
                    activity!!,
                    activity!!.packageManager,
                    activity!!.packageName
                  )
                }

                ComponentUtil.removeCurrentAppIcon(activity!!)
              }
            }
            else {
              val flutterDynamicIconPlusService = Intent(activity, FlutterDynamicIconPlusService::class.java)
              activity?.startService(flutterDynamicIconPlusService)
            }

            result.success(true)
          }
          else {
            result.error(
              "500",
              "Failed store $iconName to local storage",
              "When failed store to local storage we will provide wrong value on method getAlternateIconName"
            )
          }
        }
        else {
          result.error("500", "Activity not found", "Activity didn't attached")
        }
      }
      MethodNames.supportsAlternateIcons -> {
        if(activity != null){
          val packageInfo = ComponentUtil.packageInfo(activity!!)
          //By default, we have one activity (MainActivity).
          //If there is more than one activity, it indicates that we have an alternative activity
          val isAlternateAvailable = packageInfo.activities.size > 1
          result.success(isAlternateAvailable)
        }
        else {
          result.success(false)
        }
      }
      MethodNames.getAlternateIconName -> {
        if(activity != null){
          val enabledComponent = ComponentUtil.getCurrentEnabledAlias(activity!!)
          result.success(enabledComponent?.name)
        }
        else {
          result.error("500", "Activity not found", "Activity didn't attached")
        }
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  fun containsOnBlacklist(brandsInString: String?, manufacturesInString: String?, modelsInString: String?): Boolean {
    val brands = brandsInString?.split(",")?.toList()
    val manufactures = manufacturesInString?.split(',')?.toList()
    val models = modelsInString?.split(',')?.toList()

    val deviceBrand = Build.BRAND
    val deviceManufacture = Build.MANUFACTURER
    val deviceModel = Build.MODEL

    if (brands != null) {
      for(brand in brands){
        if(deviceBrand.equals(brand, ignoreCase = true)){
          return true
        }
      }
    }

    if(manufactures != null){
      for(manufacture in manufactures){
        if(deviceManufacture.equals(manufacture, ignoreCase = true)){
          return true
        }
      }
    }

    if(models != null){
      for(model in models){
        if(deviceModel.equals(model, ignoreCase = true))
          return true
      }
    }

    return false
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    activity = null
  }
}
