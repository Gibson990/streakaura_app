package com.example.streakaura_app

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import android.graphics.Color

/**
 * Android Home Screen Widget for StreakAura
 * Displays current streak and countdown
 */
class StreakAuraWidget : AppWidgetProvider() {
    
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {
        // Widget enabled
    }

    override fun onDisabled(context: Context) {
        // Widget disabled
    }

    companion object {
        fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            // Get data from HomeWidget shared preferences
            val prefs = context.getSharedPreferences("HomeWidgetPrefs", Context.MODE_PRIVATE)
            val streakText = prefs.getString("streak_text", "Start your glow!") ?: "Start your glow!"
            val countdownText = prefs.getString("countdown_text", "") ?: ""
            val activeToday = prefs.getString("active_today", "0/0") ?: "0/0"

            // Create RemoteViews using custom layout
            val views = RemoteViews(context.packageName, R.layout.streakaura_widget)

            // Update text views
            views.setTextViewText(R.id.widget_streak_text, streakText)
            if (countdownText.isNotEmpty()) {
                views.setTextViewText(R.id.widget_countdown, countdownText)
                views.setViewVisibility(R.id.widget_countdown, android.view.View.VISIBLE)
            } else {
                views.setViewVisibility(R.id.widget_countdown, android.view.View.GONE)
            }
            views.setTextViewText(R.id.widget_active_today, activeToday)

            // Set text colors (teal accent)
            views.setTextColor(R.id.widget_streak_text, Color.parseColor("#00D1FF"))
            views.setTextColor(R.id.widget_countdown, Color.parseColor("#FFFFFF"))
            views.setTextColor(R.id.widget_active_today, Color.parseColor("#FFFFFF"))

            // Update widget
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}

