package com.example.hardware

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.Toast
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.firebase.Firebase
import com.google.firebase.database.DataSnapshot
import com.google.firebase.database.DatabaseError
import com.google.firebase.database.ValueEventListener
import com.google.firebase.database.database
import com.journeyapps.barcodescanner.ScanContract
import com.journeyapps.barcodescanner.ScanIntentResult
import com.journeyapps.barcodescanner.ScanOptions
import android.util.Log
import android.widget.TextView
import com.google.android.material.textfield.TextInputEditText
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.auth


class principal : AppCompatActivity() {
    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private lateinit var auth: FirebaseAuth

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_principal)

        auth = Firebase.auth

        val btnqr = findViewById<Button>(R.id.cuerre)
        val btnlogout = findViewById<Button>(R.id.logout)
        val txtclave= findViewById<TextView>(R.id.mensaje)
        val txtmensaje= findViewById<TextView>(R.id.textclave)

        /*
        *
        * qrr
        *
        * */

        val barcodeLauncher = registerForActivityResult<ScanOptions, ScanIntentResult>(
            ScanContract()
        ) { result: ScanIntentResult ->
            if (result.contents == null) {
                Toast.makeText(this, "Cancelled", Toast.LENGTH_LONG).show()
            } else {
                Toast.makeText(
                    this,
                    "Clave: " + result.contents,
                    Toast.LENGTH_LONG
                ).show()



                val database = Firebase.database

                val myRef = database.getReference("clave/" + result.contents + "/estatus")
                myRef.addValueEventListener(object: ValueEventListener {

                    override fun onDataChange(snapshot: DataSnapshot) {

                        val value = snapshot.getValue(String::class.java)

                        if(value== "utilizado"){
                            txtmensaje.text = "La clave está utilizada, agregue una clave nueva."
                            txtclave.text=  "Clave: ${result.contents} (utilizado)"
                        }else{
                            txtclave.text=  "Clave: ${result.contents}"
                            txtmensaje.text = "Buen viaje"
                            writeNewData(result.contents)
                        }
                        //txtmensaje.text = value

                    }

                    override fun onCancelled(error: DatabaseError) {
                        Toast.makeText(this@principal, "Error", Toast.LENGTH_LONG).show()
                    }

                })
            }
        }
        val options = ScanOptions()
        options.setDesiredBarcodeFormats(ScanOptions.ONE_D_CODE_TYPES)
        options.setPrompt("Scan a barcode")
        options.setCameraId(0) // Use a specific camera of the device
        options.setBeepEnabled(false)
        options.setBarcodeImageEnabled(true)
        options.setOrientationLocked(false)
        //barcodeLauncher.launch(options)

        btnqr.setOnClickListener {
            barcodeLauncher.launch(ScanOptions())
        }

        btnlogout.setOnClickListener{
            super.onDestroy()
            auth.signOut()
        }

    }

    private fun writeNewData(clave: String) {
        val database = Firebase.database
        val myRef = database.getReference("clave/" + clave + "/estatus")
        myRef.setValue("utilizado")
    }

}