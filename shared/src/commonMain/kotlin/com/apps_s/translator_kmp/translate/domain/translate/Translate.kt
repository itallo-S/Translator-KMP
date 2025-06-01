package com.apps_s.translator_kmp.translate.domain.translate

import com.apps_s.translator_kmp.core.domain.language.Language
import com.apps_s.translator_kmp.core.domain.util.Resource
import com.apps_s.translator_kmp.translate.domain.history.HistoryDataSource
import com.apps_s.translator_kmp.translate.domain.history.HistoryItem

class Translate(
    private val client: TranslateClient,
    private val historyDataSource: HistoryDataSource
) {

    suspend fun execute(
        fromLanguage: Language,
        fromText: String,
        toLanguage: Language,
    ): Resource<String> {
        return try {
            val translateText = client.translate(
                fromLanguage, fromText, toLanguage
            )
            historyDataSource.insertHistoryItem(
                HistoryItem(
                    id = null,
                    fromLanguageCode = fromLanguage.langCode,
                    fromText = fromText,
                    toLanguageCode = toLanguage.langCode,
                    toText = translateText
                )
            )
            return Resource.Success(translateText)
        } catch (e: TranslateException) {
            e.printStackTrace()
            Resource.Error(e)
        }

    }
}