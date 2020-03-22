package no.agens.covid19.ui.information.Symptoms

import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.Observer
import androidx.navigation.Navigation
import androidx.navigation.fragment.findNavController
import kotlinx.android.synthetic.main.fragment_symptoms.view.*
import no.agens.covid19.R
import timber.log.Timber

class SymptomsFragment : androidx.fragment.app.Fragment() {

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?): View? {
        val root = inflater.inflate(R.layout.fragment_symptoms, container, false)

        root.buttonRegisterInfo.setOnClickListener(Navigation.createNavigateOnClickListener(R.id.symptomsStep1, null))
        root.deleteSymptoms.visibility = View.GONE

        SymptomsViewModel(root.context).observe(this.viewLifecycleOwner,
            Observer {
                if (it != null) {
                    root.textInformation.text = getString(R.string.symptoms_registrered_information_info)
                    root.buttonRegisterInfo.text = getString(R.string.register_change)

                    root.deleteSymptoms.visibility = View.VISIBLE
                    root.deleteSymptoms.setOnClickListener {
                        root.context.getSharedPreferences(SYMPTOMS_SHARED_PREFS, Context.MODE_PRIVATE)
                            .edit()
                            .putString(SYMPTOMTS_KEY, null)
                            .apply()
                        findNavController().navigate(R.id.navigation_symptoms)
                    }
                }
            })

        return root
    }
}