package com.example.myapplication

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import com.example.myapplication.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {

    lateinit var mbinding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        mbinding = DataBindingUtil.setContentView(this, R.layout.activity_main)
        mbinding.root

        mbinding.button.setOnClickListener {

            val fragment=supportFragmentManager
            val trans=fragment.beginTransaction()
            trans.replace(R.id.frame, Fragment())
            trans.commit()


        }
    }
}
