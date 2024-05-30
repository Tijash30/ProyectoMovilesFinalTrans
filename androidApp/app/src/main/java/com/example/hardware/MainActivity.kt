package com.example.hardware

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.material.textfield.TextInputEditText
import com.google.firebase.Firebase
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseUser
import com.google.firebase.auth.auth


class MainActivity : AppCompatActivity() {
    private lateinit var auth: FirebaseAuth

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)


        auth = Firebase.auth

        var botonlog= findViewById<Button>(R.id.paralogin)
        var userpass= findViewById<TextInputEditText>(R.id.contraseña)
        var usertext= findViewById<TextInputEditText>(R.id.correo)


        botonlog.setOnClickListener{
            auth.signInWithEmailAndPassword(usertext.text.toString(), userpass.text.toString()).addOnCompleteListener{
                    task ->
                if(task.isSuccessful){
                    Toast.makeText(this, "Se inició sesión", Toast.LENGTH_LONG).show()
                    startActivity(Intent(this, principal::class.java))
                }else{
                    Toast.makeText(this, "error"+task.exception!!.message.toString(), Toast.LENGTH_LONG).show()

                }
            }
        }
    }

    public override fun onStart(){
        super.onStart()
        val currentUser= auth.currentUser
        if(currentUser==null){
            Toast.makeText(this, "no hay usuarios", Toast.LENGTH_LONG).show()
        }else{
            Toast.makeText(this, "ya estás autenti", Toast.LENGTH_LONG).show()
            startActivity(Intent(this, principal::class.java))
        }
    }

    /*public override fun onDestroy() {
        super.onDestroy()
        auth.signOut()
    }*/


}