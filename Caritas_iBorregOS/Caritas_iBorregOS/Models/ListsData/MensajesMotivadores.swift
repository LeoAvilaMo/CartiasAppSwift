//
//  MensajesMotivadores.swift
//  Caritas_iBorregOS
//
//  Created by Leo A.Molina on 08/10/24.
//

import Foundation

let mensajesMotivadores: [String] = [
   "¡Sigue así, no te rindas! 👏",
   "¡Tú puedes con todo! 💪",
   "No hay imposibles para ti 🔥",
   "El éxito te espera, sigue adelante 🚀",
   "¡Eres imparable! ⚡️",
   "Cada día es una nueva oportunidad 🌅",
   "Confía en tu potencial 🌟",
   "Hoy es el día para brillar 🌞",
   "Pequeños pasos, grandes logros 🏃‍♂️",
   "No mires atrás, sigue avanzando 🏃‍♀️",
   "Lo mejor está por venir ✨",
   "¡La meta está cerca! 🏁",
   "¡Sigue tu pasión! 💖",
   "El esfuerzo vale la pena 💼",
   "Aprende de cada error 📚",
   "Tu dedicación es admirable 👏",
   "Cada día es una nueva oportunidad 🌄",
   "El esfuerzo siempre trae recompensas 🏆",
   "¡Vas por buen camino! 🚶‍♂️",
   "Nunca dejes de creer en ti ✨",
   "Sigue luchando por tus sueños 💭",
   "El progreso es progreso, no importa cuán pequeño sea 🌱",
   "La perseverancia siempre vence 💪",
   "¡Eres una estrella en ascenso! 🌠",
   "Mantén la actitud positiva 😊",
   "Con determinación, todo es posible 🎯",
   "¡Hoy será un gran día! 🌞",
   "El límite es el cielo ☁️",
   "Eres capaz de cosas increíbles 🌟",
   "Todo esfuerzo tiene su recompensa 🏆",
   "Sigue tu corazón y no te detengas ❤️",
   "Eres más fuerte de lo que crees 🦁",
   "¡Cada día es una victoria! 🏅",
   "Nunca es tarde para empezar 🌅",
   "El éxito está a la vuelta de la esquina 🔑",
   "Tu futuro es brillante ✨",
   "Paso a paso, llegarás lejos 🚶‍♀️",
   "Tienes el poder de cambiar el mundo 🌍",
   "La clave es la constancia 🔑",
   "No te rindas, estás más cerca de lo que piensas 🏁",
   "Hazlo con pasión o no lo hagas 🔥",
   "El esfuerzo de hoy será la recompensa de mañana 💎",
   "Tu actitud marca la diferencia 😎",
   "Lo mejor aún está por llegar 🚀",
   "El éxito no es casualidad, es trabajo duro 🛠️",
   "Cree en ti mismo y todo será posible ✨",
   "No pares hasta sentirte orgulloso 🏆",
   "Eres único y tienes mucho que ofrecer 🌟",
   "Sigue adelante con valentía 🦸‍♂️",
   "Tu esfuerzo no pasa desapercibido 👏"
]

func randomMotivationalMessage() -> String {
        return mensajesMotivadores.randomElement() ?? "¡Sigue adelante! 💪"
}
