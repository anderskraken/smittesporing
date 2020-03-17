package no.agens.covid19

import android.os.Build

object AppInfo {

    fun isOreoOrNewer(): Boolean = Build.VERSION.SDK_INT >= Build.VERSION_CODES.O
}
