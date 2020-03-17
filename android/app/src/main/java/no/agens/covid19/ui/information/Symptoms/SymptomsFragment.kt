package no.agens.covid19.ui.information.Symptoms

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.navigation.Navigation
import kotlinx.android.synthetic.main.fragment_symptoms.view.*
import no.agens.covid19.R

class SymptomsFragment : androidx.fragment.app.Fragment() {

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?): View? {
        val root = inflater.inflate(R.layout.fragment_symptoms, container, false)

        root.buttonRegisterInfo.setOnClickListener(Navigation.createNavigateOnClickListener(R.id.symptomsStep1, null))


        return root
    }
}