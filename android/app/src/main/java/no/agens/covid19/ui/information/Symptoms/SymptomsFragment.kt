package no.agens.covid19.ui.information.Symptoms

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.Observer
import androidx.navigation.fragment.findNavController
import kotlinx.serialization.json.Json
import no.agens.covid19.R
import timber.log.Timber

class SymptomsFragment : androidx.fragment.app.Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val root = inflater.inflate(R.layout.fragment_symptoms, container, false)

        SymptomsViewModel(root.context).observe(this.viewLifecycleOwner,
            Observer { symptoms ->
                if (symptoms != null) {
                    val json = Json.toJson(Symptoms.serializer(), symptoms).toString()
                    val action = SymptomsFragmentDirections.actionNavigationSymptomsToSymptomsSummary(json)
                    findNavController().navigate(action)
                }
            })

        return root
    }
}