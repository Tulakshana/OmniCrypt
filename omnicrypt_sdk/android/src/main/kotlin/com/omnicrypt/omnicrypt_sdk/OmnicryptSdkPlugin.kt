package com.omnicrypt.omnicrypt_sdk

import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.security.KeyStore
import java.util.UUID
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.GCMParameterSpec

/** OmnicryptSdkPlugin */
class OmnicryptSdkPlugin :
    FlutterPlugin,
    MethodCallHandler {
    // The MethodChannel that will the communication between Flutter and native Android
    //
    // This local reference serves to register the plugin with the Flutter Engine and unregister it
    // when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    private val keyStore = KeyStore.getInstance("AndroidKeyStore").apply { load(null) }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "omnicrypt_sdk")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "createKey" -> {
                val keyId = call.argument<String>("keyId") ?: UUID.randomUUID().toString()
                try {
                    createKey(keyId)
                    result.success(keyId)
                } catch (e: Exception) {
                    result.error("CREATE_KEY_FAILED", e.message, null)
                }
            }
            "encrypt" -> {
                val plaintext = call.argument<ByteArray>("plaintext")!!
                val keyId = call.argument<String>("keyId")!!
                try {
                    val ciphertext = encrypt(plaintext, keyId)
                    result.success(ciphertext)
                } catch (e: Exception) {
                    result.error("ENCRYPT_FAILED", e.message, null)
                }
            }
            "decrypt" -> {
                val ciphertext = call.argument<ByteArray>("ciphertext")!!
                val keyId = call.argument<String>("keyId")!!
                try {
                    val decrypted = decrypt(ciphertext, keyId)
                    result.success(decrypted)
                } catch (e: Exception) {
                    result.error("DECRYPT_FAILED", e.message, null)
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun createKey(keyId: String) {
        val keyGenerator = KeyGenerator.getInstance(KeyProperties.KEY_ALGORITHM_AES, "AndroidKeyStore")
        val keyGenParameterSpec = KeyGenParameterSpec.Builder(
            keyId,
            KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT
        )
            .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
            .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
            .setKeySize(256)
            .build()
        keyGenerator.init(keyGenParameterSpec)
        keyGenerator.generateKey()
    }

    private fun encrypt(plaintext: ByteArray, keyId: String): ByteArray {
        val key = keyStore.getKey(keyId, null) as SecretKey
        val cipher = Cipher.getInstance("AES/GCM/NoPadding")
        cipher.init(Cipher.ENCRYPT_MODE, key)
        val iv = cipher.iv
        val encrypted = cipher.doFinal(plaintext)
        return iv + encrypted
    }

    private fun decrypt(ciphertext: ByteArray, keyId: String): ByteArray {
        val key = keyStore.getKey(keyId, null) as SecretKey
        val cipher = Cipher.getInstance("AES/GCM/NoPadding")
        val iv = ciphertext.copyOfRange(0, 12)
        val encrypted = ciphertext.copyOfRange(12, ciphertext.size)
        val spec = GCMParameterSpec(128, iv)
        cipher.init(Cipher.DECRYPT_MODE, key, spec)
        return cipher.doFinal(encrypted)
    }
}
