import {
    BedrockRuntimeClient,
    ConversationRole,
    ConverseCommand,
} from '@aws-sdk/client-bedrock-runtime'

const client = new BedrockRuntimeClient({
    region: 'us-east-1',
})

export const handler = async () => {
    const conversation = [
        {
            role: 'user' as ConversationRole,
            content: [
                {
                    text: 'What is a good type of taco?',
                },
            ],
        },
    ]

    const command = new ConverseCommand({
        modelId: 'anthropic.claude-3-haiku-20240307-v1:0',
        messages: conversation,
    })

    const response = await client.send(command)

    console.log('the response', response)
    console.log('the response output', response.output?.message?.content)
    return response.output?.message?.content
}
