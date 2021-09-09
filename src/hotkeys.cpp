#include "pch.h"
#include "Hotkeys.h"

Hotkey newObjKey(VK_KEY_N, VK_KEY_N);
Hotkey copyKey(VK_LCONTROL, VK_KEY_C);
Hotkey pasteKey(VK_LCONTROL, VK_KEY_V);
Hotkey deleteKey(VK_DELETE, VK_DELETE);
Hotkey snapKey(VK_KEY_Z, VK_KEY_Z);
Hotkey editorOpenKey(VK_LCONTROL, VK_TAB);
Hotkey viewportSwitchKey(VK_KEY_E, VK_KEY_E);

bool Hotkey::DrawUI(const char* label)
{
	bool active = m_CurrentHotkey == label;
	bool state = false;

	if (active)
	{
		ImGui::PushStyleColor(ImGuiCol_Button, ImGui::GetStyle().Colors[ImGuiCol_ButtonActive]);
		ImGui::PushStyleColor(ImGuiCol_ButtonHovered, ImGui::GetStyle().Colors[ImGuiCol_ButtonActive]);

		for (int key = 3; key != 135; ++key)
		{
			if (KeyPressed(key))
			{
				m_key1 = key;
				break;
			}
		}

		for (int key = 135; key != 3; --key)
		{
			if (KeyPressed(key))
			{
				m_key2 = key;
				break;
			}
		}
	}

	std::string text;

	if (m_key1 != VK_NONE)
	{
		text = key_names[m_key1 - 1];
	}
	else
	{
		text = "None";
	}

	if (m_key1 != m_key2)
		text += (" + " + key_names[m_key2 - 1]);

	if (ImGui::Button((text + std::string("##") + std::string(label)).c_str(),
		ImVec2(ImGui::GetWindowContentRegionWidth() / 3.5, ImGui::GetFrameHeight())))
	{
		if (!active)
		{
			m_CurrentHotkey = label;
		}
	}

	if (active && ImGui::IsMouseClicked(ImGuiMouseButton_Left))
	{
		m_CurrentHotkey = "";
		state = true;
	}

	if (ImGui::IsMouseClicked(ImGuiMouseButton_Right))
	{
		if (ImGui::IsItemHovered())
		{
			m_key1 = VK_NONE;
			m_key2 = VK_NONE;
		}
		else
		{
			m_CurrentHotkey = "";
		}

		state = true;
	}

	ImGui::SameLine();
	ImGui::Text(label);

	if (active)
	{
		ImGui::PopStyleColor(2);
	}

	return state;
}

bool Hotkey::Pressed()
{
	if (KeyPressed(m_key1) && KeyPressed(m_key2))
		m_bPressed = true;
	else
	{
		if (m_bPressed)
		{
			m_bPressed = false;
			return m_CurrentHotkey == "";
		}
	}
	return false;
}

std::string Hotkey::GetNameString()
{
	std::string text;

	if (m_key1 != VK_NONE)
	{
		text = key_names[m_key1 - 1];
	}
	else
	{
		text = "None";
	}

	if (m_key1 != m_key2)
	{
		text += (" + " + key_names[m_key2 - 1]);
	}

	return text;
}